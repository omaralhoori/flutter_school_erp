import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/announcement.dart';
import 'package:school_erp/model/comment.dart';
import 'package:school_erp/model/contact_message_request.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/model/get_doc_response.dart';
import 'package:school_erp/model/login/login_request.dart';
import 'package:school_erp/model/login/login_response.dart';
import 'package:school_erp/model/messaging/message.dart';
import 'package:school_erp/model/parent/parent.dart';
import 'package:school_erp/model/payment/parent_payment.dart';
import 'package:school_erp/model/post_version.dart';
import 'package:school_erp/model/update_profile_response.dart';
import 'package:school_erp/model/user_data.dart';

abstract class Api {
  Future<LoginResponse> login(
    LoginRequest loginRequest,
  );

  Future<DoctypeResponse> getDoctype(
    String doctype,
  );

  Future<GetDocResponse> getdoc(String doctype, String name);

  Future<List> fetchList({
    required List fieldnames,
    required String doctype,
    required DoctypeDoc meta,
    required String orderBy,
    List? filters,
    int? pageLength,
    int? offset,
  });

  Future<Map> searchLink({
    required String doctype,
    String? refDoctype,
    required String txt,
    int? pageLength,
  });

  Future<Map> getContactList(String query);

  Future<List<Announcement>> getAnnouncements();

  Future<List<Album>> getGallery();

  Future<Content?> getContent(String name, String type);

  Future<List<Content>> getContents(int skip);

  Future<Content?> getAnnouncement(String name);

  Future<Content?> getNews(String name);

  Future<UserData?> getUserData();

  Future<UpdateProfileResponse> updateUserProfile(UserData userData);

  Future<Map> sendContactMessage(ContactMessageRequest request);

  Future<void> updateDeviceToken(String token);

  Future<List<Message>> getMessages();

  Future<String> addMessageReply(String message, String messageName);

  Future<bool> deleteMessageRpelies(String message, String replies);

  Future<void> viewMessage(String messageName);

  Future<List<dynamic>> getUnreadMessages();

  Future<void> contentLike(Content content);

  Future<void> contentDisLike(Content content);

  Future<void> contentView(Content content);

  Future<bool> addContentComment(Content content, String comment);

  Future<List<Comment>> getContentComments(Content content);

  Future<List<PostVersion>?> getContentVersions();

  Future downloadPaymentPdf({String? studentNo});

  Future<ParentPayment?> getParentPayments(String? studentNo);

  Future<Parent?> getParentData();
}
