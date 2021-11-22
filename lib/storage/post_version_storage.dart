import 'package:school_erp/model/post_version.dart';

import '../app/locator.dart';

import '../services/storage_service.dart';

class PostVersionStorage {
  static var storage = locator<StorageService>().getHiveBox('posts_versions');

  static putAllVersions(List<PostVersion> data) async {
    var v = {};
    for (PostVersion content in data) {
      v[content.type + "#@#" + content.name] = content;
    }
    await storage.putAll(v);
  }

  static PostVersion? getItem(String type, String name) {
    var k = type + "#@#" + name;
    if (storage.get(k) == null) return null;
    return storage.get(k) as PostVersion;
  }

  static List<PostVersion> getVersions() {
    Iterable<dynamic> values = storage.values;
    List<PostVersion> contents = List.from(values.map((e) => e as PostVersion));
    return contents;
  }

  static Future removeItem(String type, String name) async {
    var k = type + "#@#" + name;
    storage.delete(k);
  }

  static Future deleteVersions() async {
    await storage.clear();
  }
}
