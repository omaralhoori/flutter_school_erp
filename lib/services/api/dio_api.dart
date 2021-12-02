import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/announcement.dart';
import 'package:school_erp/model/comment.dart';
import 'package:school_erp/model/common.dart';
import 'package:school_erp/model/contact_message_request.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/model/get_doc_response.dart';
import 'package:school_erp/model/login/login_request.dart';
import 'package:school_erp/model/login/login_response.dart';
import 'package:school_erp/model/messaging/message.dart';
import 'package:school_erp/model/post_version.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/storage/offline_storage.dart';
import 'package:school_erp/model/parent/parent.dart';
import 'package:school_erp/model/payment/parent_payment.dart';
import 'package:school_erp/model/update_profile_response.dart';
import 'package:school_erp/model/user_data.dart';
import 'package:school_erp/utils/dio_helper.dart';
import 'package:school_erp/utils/helpers.dart';
import 'package:school_erp/utils/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/api/api.dart';

class DioApi implements Api {
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await DioHelper.dio!.post(
        '/method/login',
        data: loginRequest.toJson(),
        options: Options(validateStatus: (status) => status! < 600),
      );

      if (response.statusCode != HttpStatus.ok ||
          response.headers.map["set-cookie"] == null)
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        );

      response.data["user_id"] =
          response.headers.map["set-cookie"]![3].split(';')[0].split('=')[1];

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      if (!(e is DioError)) rethrow;

      final error = e.error;
      if (error is SocketException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: error.message,
        );
      }

      if (error is HandshakeException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: "Cannot connect securely to server."
              " Please ensure that the server has a valid SSL configuration.",
        );
      }

      throw ErrorResponse(statusMessage: error.message);
    }
  }

  Future<DoctypeResponse> getDoctype(String doctype) async {
    var queryParams = {
      'doctype': doctype,
    };

    try {
      final response = await DioHelper.dio!.get(
        '/method/frappe.desk.form.load.getdoctype',
        queryParameters: queryParams,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        List metaFields = response.data["docs"][0]["fields"];
        response.data["docs"][0]["field_map"] = {};

        metaFields.forEach((field) {
          response.data["docs"][0]["field_map"]["${field["fieldname"]}"] = true;
        });
        if (await OfflineStorage.storeApiResponse()) {
          await OfflineStorage.putItem('${doctype}Meta', response.data);
        }
        return DoctypeResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse(
          statusMessage: response.statusMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  Future<List> fetchList({
    required List fieldnames,
    required String doctype,
    required DoctypeDoc meta,
    required String orderBy,
    List? filters,
    int? pageLength,
    int? offset,
  }) async {
    var queryParams = {
      'doctype': doctype,
      'fields': jsonEncode(fieldnames),
      'page_length': pageLength.toString(),
      'with_comment_count': true,
      'order_by': orderBy
    };

    queryParams['limit_start'] = offset.toString();

    if (filters != null && filters.length != 0) {
      queryParams['filters'] = jsonEncode(filters);
    }

    try {
      final response = await DioHelper.dio!.get(
        '/method/frappe.desk.reportview.get',
        queryParameters: queryParams,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        var l = response.data["message"];
        var newL = [];

        if (l.length == 0) {
          return newL;
        }

        for (int i = 0; i < l["values"].length; i++) {
          var o = {};
          for (int j = 0; j < l["keys"].length; j++) {
            var key = l["keys"][j];
            var value = l["values"][i][j];

            if (key == "docstatus") {
              key = "status";
              if (isSubmittable(meta)) {
                if (value == 0) {
                  value = "Draft";
                } else if (value == 1) {
                  value = "Submitted";
                } else if (value == 2) {
                  value = "Cancelled";
                }
              } else {
                value = value == 0 ? "Enabled" : "Disabled";
              }
            }
            o[key] = value;
          }
          newL.add(o);
        }

        if (await OfflineStorage.storeApiResponse()) {
          await OfflineStorage.putItem('${doctype}List', newL);
        }

        return newL;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  Future<Map> searchLink({
    required String doctype,
    String? refDoctype,
    required String txt,
    int? pageLength,
  }) async {
    var queryParams = {
      'txt': txt,
      'doctype': doctype,
      'reference_doctype': refDoctype,
      'ignore_user_permissions': 0,
    };

    if (pageLength != null) {
      queryParams['page_length'] = pageLength;
    }

    try {
      final response = await DioHelper.dio!.post(
        '/method/frappe.desk.search.search_link',
        data: queryParams,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        if (await OfflineStorage.storeApiResponse()) {
          if (pageLength != null && pageLength == 9999) {
            await OfflineStorage.putItem('${doctype}LinkFull', response.data);
          } else {
            await OfflineStorage.putItem('$txt${doctype}Link', response.data);
          }
        }
        return response.data;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw e;
      }
    }
  }

  Future<Map> getContactList(String query) async {
    var data = {
      "txt": query,
    };

    final response = await DioHelper.dio!.post(
        '/method/frappe.email.get_contact_list',
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType));
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<GetDocResponse> getdoc(String doctype, String name) async {
    var queryParams = {
      'doctype': doctype,
      'name': name,
    };

    try {
      final response = await DioHelper.dio!.get(
        '/method/frappe.desk.form.load.getdoc',
        queryParameters: queryParams,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        if (await OfflineStorage.storeApiResponse()) {
          await OfflineStorage.putItem('$doctype$name', response.data);
        }
        return GetDocResponse.fromJson(response.data);
      } else if (response.statusCode == 403) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage!,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw e;
      }
    }
  }

  Future<List<Announcement>> getAnnouncements() async {
    var data = {};
    List<Announcement> announcementList = [];
    if (DioHelper.dio == null) {
      try {
        DioHelper.init();
      } catch (e) {}
    }
    data["user"] = await Palette.deviceID();
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.announcement.announcement.get_announcements',
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        for (var json in response.data["message"]) {
          Announcement announcement = Announcement.fromJson(json);
          announcementList.add(announcement);
        }
      } else {
        throw Exception('Something went wrong');
      }
    }
    return announcementList;
  }

  @override
  Future<List<Album>> getGallery() async {
    var data = {};
    List<Album> albumList = [];
    if (DioHelper.dio == null) {
      try {
        DioHelper.init();
      } catch (e) {}
    }
    data["user"] = await Palette.deviceID();
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.gallery_album.gallery_album.get_albums',
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        for (var json in response.data["message"]) {
          Album album = Album.fromJson(json);
          albumList.add(album);
        }
      } else {
        throw Exception('Something went wrong');
      }
    }
    return albumList;
  }

  @override
  Future<List<Content>> getContents(int skip) async {
    var data = {"limit": "10", "skip": skip.toString()};
    List<Content> contentList = [];
    if (DioHelper.dio == null) {
      try {
        DioHelper.init();
      } catch (e) {}
    }
    data["user"] = await Palette.deviceID();
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.announcement.announcement.get_all_contents',
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        for (var json in response.data["message"]) {
          Content content = Content.fromJson(json);
          contentList.add(content);
        }
      } else {
        throw Exception('Something went wrong');
      }
    }
    return contentList;
  }

  Future<Content?> getAnnouncement(String name) async {
    var data = {"announcement": name};
    if (DioHelper.dio == null) {
      try {
        DioHelper.init();
      } catch (e) {}
    }
    data["user"] = await Palette.deviceID();
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.announcement.announcement.get_announcement',
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        for (var json in response.data["message"]) {
          return Content.fromJson(json);
        }
      } else {
        throw Exception('Something went wrong');
      }
    }
  }

  Future<Content?> getNews(String name) async {
    var data = {"news": name};
    if (DioHelper.dio == null) {
      try {
        DioHelper.init();
      } catch (e) {}
    }
    data["user"] = await Palette.deviceID();
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.news.news.get_single_news',
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        for (var json in response.data["message"]) {
          return Content.fromJson(json);
        }
      } else {
        throw Exception('Something went wrong');
      }
    }
  }

  Future<UserData?> getUserData() async {
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.user.get_user_data',
          data: {},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (response.statusCode == 200) {
        UserData userData = UserData.fromJson(response.data["message"]);
        return userData;
      } else {
        throw Exception('Something went wrong');
      }
    }
    return null;
  }

  Future<UpdateProfileResponse> updateUserProfile(UserData userData) async {
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.user.update_user_info',
          data: userData.toJson(),
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (response.statusCode == 200) {
        UpdateProfileResponse res =
            UpdateProfileResponse.fromJson(response.data["message"]);
        return res;
      } else {
        throw Exception('Something went wrong');
      }
    }
    return UpdateProfileResponse(errorMessage: "Something went wrong");
  }

  Future<String?> updateUserProfileImage(XFile image) async {
    if (DioHelper.dio != null) {
      FormData formData = FormData.fromMap({
        "filedata":
            await MultipartFile.fromFile(image.path, filename: image.name),
        "filename": image.name,
      });
      //var data = {"filename": image.name, "filedata": File(image.path).};
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.upload_img.update_user_image',
          data: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (response.statusCode == 200) {
        return response.data["message"]["file_url"];
      }
    }
  }

  Future<Map> sendContactMessage(ContactMessageRequest request) async {
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.contact_messages.contact_messages.send_message',
          data: request.toJson(),
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (response.statusCode == 200) {
        return {"message": "Message sent successfully"};
      } else {
        throw Exception('Something went wrong');
      }
    }
    return {"errorMessage": "Something went wrong"};
  }

  Future<void> updateDeviceToken(String token) async {
    var data = {"device_token": token};
    if (DioHelper.dio != null) {
      await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.notification.update_device_token',
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
  }

  Future<bool> deleteDeviceToken() async {
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.notification.delete_device_token',
          data: {},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  Future<List<Message>> getMessages() async {
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.school_messaging.school_messaging.get_messages',
          data: {},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        Iterable i = response.data["message"];
        List<Message> messages = List.from(
            i.map((message) => Message.fromJson(message))); //List.empty();
        // for (var message in response.data["message"]) {
        //   messages.add(Message.fromJson(message));
        // }
        return messages;
      } else {
        throw Exception('Something went wrong');
      }
    }
    return [];
  }

  Future<String> addMessageReply(String message, String messageName) async {
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.school_messaging.school_messaging.add_reply',
          data: {"reply": message, "message_name": messageName},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        return response.data["message"]["name"];
      } else {
        return "";
      }
    }
    return "";
  }

  Future<bool> deleteMessageRpelies(String message, String replies) async {
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.school_messaging.school_messaging.delete_replies',
          data: {"message_name": message, "replies": replies},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<void> viewMessage(String messageName) async {
    if (DioHelper.dio != null) {
      await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.school_messaging.school_messaging.view_message',
          data: {"message_name": messageName},
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
  }

  Future<List<dynamic>> getUnreadMessages() async {
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.school_messaging.school_messaging.get_unread_messages',
          data: {},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        return response.data["message"];
      }
    }
    return [];
  }

  @override
  Future<void> contentLike(String name, String type) async {
    var data;
    String url;
    if (type == 'News') {
      url = '/method/mobile_backend.mobile_backend.doctype.news.news.like_news';
      data = {"news": name};
    } else if (type == 'Announcement') {
      url =
          '/method/mobile_backend.mobile_backend.doctype.announcement.announcement.like_announcement';
      data = {"announcement": name};
    } else {
      url =
          '/method/mobile_backend.mobile_backend.doctype.gallery_album.gallery_album.like_album';
      data = {"album": name};
    }
    data["user"] = await Palette.deviceID();
    if (DioHelper.dio != null) {
      await DioHelper.dio!.post(url,
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
  }

  @override
  Future<void> contentView(String name, String type) async {
    var data;
    String url;
    if (type == 'News') {
      url = '/method/mobile_backend.mobile_backend.doctype.news.news.view_news';
      data = {"news": name};
    } else if (type == 'Announcement') {
      url =
          '/method/mobile_backend.mobile_backend.doctype.announcement.announcement.view_announcement';
      data = {"announcement": name};
    } else {
      url =
          '/method/mobile_backend.mobile_backend.doctype.gallery_album.gallery_album.view_album';
      data = {"album": name};
    }
    data["user"] = await Palette.deviceID();
    if (DioHelper.dio != null) {
      await DioHelper.dio!.post(url,
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
  }

  @override
  Future<void> contentDisLike(String name, String type) async {
    var data;
    String url;
    if (type == 'News') {
      url =
          '/method/mobile_backend.mobile_backend.doctype.news.news.dislike_news';
      data = {"news": name};
    } else if (type == 'Announcement') {
      url =
          '/method/mobile_backend.mobile_backend.doctype.announcement.announcement.dislike_announcement';
      data = {"announcement": name};
    } else {
      url =
          '/method/mobile_backend.mobile_backend.doctype.gallery_album.gallery_album.dislike_album';
      data = {"album": name};
    }
    data["user"] = await Palette.deviceID();
    if (DioHelper.dio != null) {
      await DioHelper.dio!.post(url,
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
  }

  Future<List<PostVersion>?> getContentVersions() async {
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(
          '/method/mobile_backend.mobile_backend.doctype.announcement.announcement.get_contents_version',
          data: {},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (response.statusCode == 200) {
        Iterable i = response.data["message"];
        List<PostVersion> comments =
            List.from(i.map((message) => PostVersion.fromJson(message)));
        return comments;
      }
    }
    return null;
  }

  Future<List<Comment>> getContentComments(String name, String type) async {
    var data;
    String url;
    if (type == 'News') {
      url =
          '/method/mobile_backend.mobile_backend.doctype.news.news.get_comments';
      data = {"news": name};
    } else if (type == 'Announcement') {
      url =
          '/method/mobile_backend.mobile_backend.doctype.announcement.announcement.get_comments';
      data = {"announcement": name};
    } else {
      url =
          '/method/mobile_backend.mobile_backend.doctype.gallery_album.gallery_album.get_comments';
      data = {"album": name};
    }
    data["user"] = await Palette.deviceID();
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(url,
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        Iterable i = response.data["message"];
        List<Comment> comments =
            List.from(i.map((message) => Comment.fromJson(message)));
        return comments;
      }
    }
    return [];
  }

  Future<bool> addContentComment(
      String name, String type, String comment) async {
    var data;
    String url;
    if (type == 'News') {
      url =
          '/method/mobile_backend.mobile_backend.doctype.news.news.add_comment';
      data = {"news": name};
    } else if (type == 'Announcement') {
      url =
          '/method/mobile_backend.mobile_backend.doctype.announcement.announcement.add_comment';
      data = {"announcement": name};
    } else {
      url =
          '/method/mobile_backend.mobile_backend.doctype.gallery_album.gallery_album.add_comment';
      data = {"album": name};
    }
    data["user"] = await Palette.deviceID();
    data["comment"] = comment;
    if (DioHelper.dio != null) {
      final response = await DioHelper.dio!.post(url,
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  Future downloadPaymentPdf({String? studentNo}) async {
    // String url =
    //     '/method/mobile_backend.mobile_backend.pdf.get_parent_transactions_pdf';
    // if (studentNo != null) {
    //   url += "?PSTD=$studentNo";
    // }
    // String fullUrl = "${Config.baseUrl}/api${url}";
    // launch(fullUrl);
    if (DioHelper.dio != null) {
      //String url = '/method/mobile_backend.mobile_backend.pdf.get_transactions_pdf?PBRN=$branch&PYEAR=$year&PCONNO=$contract';
      String url =
          '/method/mobile_backend.mobile_backend.pdf.get_parent_transactions_pdf';
      if (studentNo != null) {
        url += "?PSTD=$studentNo";
      }
      String fileName = "payments.pdf";
      openFile(url: url, fileName: fileName);
    }
  }

  Future<ParentPayment?> getParentPayments(String? studentNo) async {
    var data = {};
    if (studentNo != null) {
      data["PSTD"] = studentNo;
    }
    if (DioHelper.dio != null) {
      try {
        final response = await DioHelper.dio!.post(
            '/method/mobile_backend.mobile_backend.pdf.get_user_payments',
            data: data,
            options: Options(contentType: Headers.formUrlEncodedContentType));
        if (response.statusCode == 200) {
          return ParentPayment.fromJson(response.data["message"]);
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<Parent?> getParentData() async {
    var data = {};
    if (DioHelper.dio != null) {
      try {
        final response = await DioHelper.dio!.post(
            '/method/mobile_backend.mobile_backend.user.get_parent_data',
            data: data,
            options: Options(contentType: Headers.formUrlEncodedContentType));
        if (response.statusCode == 200) {
          return Parent.fromJson(response.data["message"]);
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  @override
  Future<Content?> getContent(String name, String type) async {
    if (type == 'News') {
      return getNews(name);
    } else if (type == 'Announcement') {
      return getAnnouncement(name);
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> getSchoolBranches() async {
    if (DioHelper.dio != null) {
      try {
        final response = await DioHelper.dio!.post(
            '/method/mobile_backend.mobile_backend.doctype.school_branch.school_branch.get_branches',
            data: {},
            options: Options(contentType: Headers.formUrlEncodedContentType));
        if (response.statusCode == 200) {
          return response.data["message"];
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<List<dynamic>?> getSchoolClasses() async {
    if (DioHelper.dio != null) {
      try {
        final response = await DioHelper.dio!.post(
            '/method/mobile_backend.mobile_backend.doctype.school_branch.school_branch.get_classes',
            data: {},
            options: Options(contentType: Headers.formUrlEncodedContentType));
        if (response.statusCode == 200) {
          return response.data["message"];
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<List<dynamic>?> getSchoolSections() async {
    if (DioHelper.dio != null) {
      try {
        final response = await DioHelper.dio!.post(
            '/method/mobile_backend.mobile_backend.doctype.school_branch.school_branch.get_sections',
            data: {},
            options: Options(contentType: Headers.formUrlEncodedContentType));
        if (response.statusCode == 200) {
          return response.data["message"];
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  }
}
