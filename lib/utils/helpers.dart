import 'dart:io';
import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/config.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/model/offline_storage.dart';
import 'package:tuple/tuple.dart';
import 'package:school_erp/model/announcement.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/services/storage_service.dart';

import '../app/locator.dart';
import 'dio_helper.dart';
import 'enums.dart';

initDb() async {
  await locator<StorageService>().initHiveStorage();

  locator<StorageService>()
      .registerAdapter<Announcement>(AnnouncementAdapter());
  locator<StorageService>().registerAdapter<Album>(AlbumAdapter());
  locator<StorageService>().registerAdapter<Content>(ContentAdapter());

  await locator<StorageService>().initHiveBox('queue');
  await locator<StorageService>().initHiveBox('offline');
  await locator<StorageService>().initHiveBox('posts');
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

clearLoginInfo() async {
  var cookie = await DioHelper.getCookiePath();
  if (Config().uri != null) {
    cookie.delete(
      Config().uri!,
    );
  }
  OfflineStorage.remove("pwd");
  Config.set('isLoggedIn', false);
}

Tuple2<String, int> getCreatedBefore(String date) {
  //DateFormat format = new DateFormat("yyyy-MM-dd hh:mm:ss");
  DateTime now = DateTime.now();
  DateTime creation = parseDate(date); //format.parse(date);
  int difference = now.difference(creation).inSeconds;

  return Tuple2('Seconds', difference);
}

MessageType getMessageType(String type) {
  if (type == "School Direct Message") {
    return MessageType.direct;
  } else if (type == "School Group Message") {
    return MessageType.group;
  }

  return MessageType.direct;
}
