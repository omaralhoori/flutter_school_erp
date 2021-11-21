import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_erp/services/notifications.dart';
import '../app/locator.dart';
import '../services/api/api.dart';

import '../utils/dio_helper.dart';
import '../storage/offline_storage.dart';
import '../storage/config.dart';

initApiConfig() async {
  await DioHelper.init();
  await DioHelper.initCookies();
}

Future<void> cacheAllUsers() async {
  var allUsers = OfflineStorage.getItem('allUsers');
  allUsers = allUsers["data"];
  if (allUsers != null) {
    return;
  } else {
    var fieldNames = [
      "`tabUser`.`name`",
      "`tabUser`.`full_name`",
      "`tabUser`.`user_image`",
    ];

    var filters = [
      ["User", "enabled", "=", 1]
    ];

    try {
      var meta = await locator<Api>().getDoctype('User');

      var res = await locator<Api>().fetchList(
        fieldnames: fieldNames,
        doctype: 'User',
        orderBy: '`tabUser`.`modified` desc',
        filters: filters,
        meta: meta.docs[0],
      );

      var usr = {};
      res.forEach(
        (element) {
          usr[element["name"]] = element;
        },
      );
      OfflineStorage.putItem('allUsers', usr);
    } catch (e) {
      throw e;
    }
  }
}

Future<void> updateDeviceToken() async {
  String token = await Notifications.getDeviceToken();
  await locator<Api>().updateDeviceToken(token);
}

Future<void> setBaseUrl(url) async {
  // if (!url.startsWith('https://')) {
  //   url = "https://$url";
  // }
  await Config.set('baseUrl', url);
  await DioHelper.init();
}

String getAbsoluteUrl(String url) {
  return Uri.encodeFull("${Config.baseUrl}$url");
}

Future<File?> downloadFile(String url, String name) async {
  final appStorage = await getExternalStorageDirectory();
  final file = File('${appStorage!.path}/$name');
  try {
    final response = await DioHelper.dio!.get(url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0));
    if (response.statusCode == 200) {
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data.cast<int>());
      await raf.close();
    }

    return file;
  } catch (e) {
    print(e);
    return null;
  }
}

Future openFile({required String url, String? fileName}) async {
  final file = await downloadFile(url, fileName!);
  if (file == null) return;
  OpenFile.open(file.path);
}
