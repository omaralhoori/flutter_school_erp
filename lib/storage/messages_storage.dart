import 'package:school_erp/model/messaging/message.dart';
import 'package:school_erp/utils/helpers.dart';

import '../app/locator.dart';

import '../services/storage_service.dart';

class MessagesStorage {
  static var storage = locator<StorageService>().getHiveBox('messages');

  static putAllMessages(List<Message> data) async {
    var v = {};
    for (Message content in data) {
      v[content.name] = content;
    }
    await storage.putAll(v);
  }

  static Message? getItem(String name) {
    var k = name;
    if (storage.get(k) == null) return null;
    return storage.get(k) as Message;
  }

  static List<Message> getMessages() {
    Iterable<dynamic> values = storage.values;
    List<Message> contents = List.from(values.map((e) => e as Message));
    contents
        .sort((b, a) => parseDate(a.creation).compareTo(parseDate(b.creation)));
    return contents;
  }

  static Future removeItem(String name) async {
    var k = name;
    storage.delete(k);
  }

  static Future deleteMessages() async {
    await storage.clear();
  }
}
