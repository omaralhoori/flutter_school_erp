import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:school_erp/model/common.dart';
import 'package:school_erp/model/config.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/model/get_doc_response.dart';
import 'package:school_erp/model/login/login_request.dart';
import 'package:school_erp/model/login/login_response.dart';
import 'package:school_erp/model/models.dart';
import 'package:school_erp/model/offline_storage.dart';
import 'package:school_erp/utils/dio_helper.dart';
import 'package:school_erp/utils/helpers.dart';

import '../../services/api/api.dart';

class DioApi implements Api {
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await DioHelper.dio!.post(
        '/method/login',
        data: loginRequest.toJson(),
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode != HttpStatus.ok ||
          response.headers.map["set-cookie"] == null ||
          response.headers.map["set-cookie"]![3] == null)
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
}
