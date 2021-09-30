import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../app/locator.dart';

import '../services/storage_service.dart';
import '../services/api/api.dart';

import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'common.dart';
import 'config.dart';
import 'doctype_response.dart';

class OfflineStorage {
  static var storage = locator<StorageService>().getHiveBox('offline');

  static String generateKeyHash(String key) {
    return sha1.convert(utf8.encode(key)).toString();
  }

  static putItem(String secondaryKey, dynamic data) async {
    if (Config().primaryCacheKey == null) {
      return;
    }

    var k = Config().primaryCacheKey! + "#@#" + secondaryKey;
    var kHash = generateKeyHash(k);

    var v = {
      'timestamp': DateTime.now(),
      'data': data,
    };

    await storage.put(kHash, v);
  }

  static putAllItems(Map data, [bool isIsolate = false]) async {
    if (Config().primaryCacheKey == null) {
      return;
    }

    var v = {};

    data.forEach(
      (key, value) {
        v[generateKeyHash(Config().primaryCacheKey! + "#@#" + key)] = {
          'timestamp': DateTime.now(),
          "data": value,
        };
      },
    );

    if (isIsolate) {
      var runBackgroundTask = await locator<StorageService>()
          .getSharedPrefBoolValue("backgroundTask");
      if (runBackgroundTask ?? false) {
        await storage.putAll(v);
      }
    } else {
      await storage.putAll(v);
    }
  }

  static getItem(String secondaryKey) {
    if (Config().primaryCacheKey == null) {
      return {"data": null};
    }
    var k = Config().primaryCacheKey! + "#@#" + secondaryKey;
    var keyHash = generateKeyHash(k);

    if (storage.get(keyHash) == null) {
      return {"data": null};
    }

    return storage.get(keyHash);
  }

  static Future remove(String secondaryKey) async {
    var k = Config().primaryCacheKey! + "#@#" + secondaryKey;
    var keyHash = generateKeyHash(k);
    storage.delete(keyHash);
  }

  static Future<Map> storeDoctypeMeta(String doctype) async {
    var cache = {};
    try {
      var response = await locator<Api>().getDoctype(doctype);
      cache['${doctype}Meta'] = response.toJson();
    } catch (e) {
      print(e);
    }

    return cache;
  }

  static Future<Map> storeDoc(String doctype, String docName) async {
    var cache = {};
    try {
      var docForm = await locator<Api>().getdoc(doctype, docName);
      cache['$doctype$docName'] = docForm;
    } catch (e) {
      print(e);
    }
    return cache;
  }

  static Future<bool> storeApiResponse() async {
    var storeApiResponse =
        await locator<StorageService>().getSharedPrefBoolValue(
      "storeApiResponse",
    );
    return storeApiResponse ?? true;
  }

  static Future<DoctypeResponse> getMeta(String doctype) async {
    try {
      var isOnline = await verifyOnline();

      DoctypeResponse metaResponse;

      if (isOnline) {
        metaResponse = await locator<Api>().getDoctype(doctype);
      } else {
        var cachedMeta = getItem('${doctype}Meta');
        if (cachedMeta["data"] != null) {
          metaResponse = DoctypeResponse.fromJson(
            Map<String, dynamic>.from(
              cachedMeta["data"],
            ),
          );
        } else {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage:
                "$doctype is currently not available for offline use",
          );
        }
      }
      return metaResponse;
    } catch (e) {
      throw e;
    }
  }
}
