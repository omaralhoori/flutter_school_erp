import 'dart:convert';
import 'dart:io';

import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/services/storage_service.dart';

import '../app/locator.dart';

initDb() async {
  await locator<StorageService>().initHiveStorage();

  await locator<StorageService>().initHiveBox('queue');
  await locator<StorageService>().initHiveBox('offline');
  await locator<StorageService>().initHiveBox('config');
}

Future<bool> verifyOnline() async {
  bool isOnline = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isOnline = true;
    } else
      isOnline = false;
  } on SocketException catch (_) {
    isOnline = false;
  }

  return isOnline;
}

bool isSubmittable(DoctypeDoc meta) {
  return meta.isSubmittable == 1;
}

DateTime parseDate(val) {
  if (val == null) {
    return DateTime.now();
  } else if (val == "Today") {
    return DateTime.now();
  } else {
    return DateTime.parse(val);
  }
}
