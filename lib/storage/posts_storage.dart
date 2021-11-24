import 'package:school_erp/model/content.dart';

import '../app/locator.dart';

import '../services/storage_service.dart';

import '../utils/helpers.dart';
import 'config.dart';

class PostsStorage {
  static var storage = locator<StorageService>().getHiveBox('posts');

  static putContent(Content content) async {
    String k = content.contentType + "#@#" + content.name;

    try {
      await storage.put(k, content);
    } catch (e) {
      throw e;
    }
  }

  static putAllContents(List<Content> data) async {
    if (Config().primaryCacheKey == null) {
      return;
    }

    var v = {};
    for (Content content in data) {
      v[content.contentType + "#@#" + content.name] = content;
    }
    await storage.putAll(v);
  }

  static Content? getItem(String type, String name) {
    var k = type + "#@#" + name;
    if (storage.get(k) == null) return null;
    return storage.get(k) as Content;
  }

  static List<Content> getContents() {
    Iterable<dynamic> values = storage.values;
    List<Content> contents = List.from(values.map((e) => e as Content));
    contents
        .sort((b, a) => parseDate(a.creation).compareTo(parseDate(b.creation)));
    return contents;
  }

  static Future removeItem(String type, String name) async {
    var k = type + "#@#" + name;
    storage.delete(k);
  }
}
