import 'package:flutter/foundation.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/model/get_doc_response.dart';
import 'package:school_erp/model/login/login_request.dart';
import 'package:school_erp/model/login/login_response.dart';

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
}
