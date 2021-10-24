import 'dart:convert';
import 'dart:io';
import 'package:school_erp/model/album.dart';
import 'package:tuple/tuple.dart';
import 'package:school_erp/model/announcement.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/services/storage_service.dart';

import '../app/locator.dart';

initDb() async {
  await locator<StorageService>().initHiveStorage();

  locator<StorageService>().registerAdapter<Announcement>(AnnouncementAdapter());
  locator<StorageService>().registerAdapter<Album>(AlbumAdapter());

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

Tuple2<String, int> getCreatedBefore(String date) {
  //DateFormat format = new DateFormat("yyyy-MM-dd hh:mm:ss");
  DateTime now = DateTime.now();
  DateTime creation = parseDate(date); //format.parse(date);
  int difference = now.difference(creation).inSeconds;

  return Tuple2('Seconds', difference);
}
