import '../services/storage_service.dart';
import '../app/locator.dart';

class Config {
  static var configContainer = locator<StorageService>().getHiveBox('config');

  bool get isLoggedIn => configContainer.get(
        'isLoggedIn',
        defaultValue: false,
      );
  bool get isGuest => configContainer.get(
        'isGuest',
        defaultValue: false,
      );
  bool get isTeacher => configContainer.get(
        'isTeacher',
        defaultValue: false,
      );
  bool get isParent => configContainer.get(
        'isParent',
        defaultValue: false,
      );

  String? get userId =>
      Uri.decodeFull(configContainer.get('userId', defaultValue: ""));
  String get user => configContainer.get('user');
  String? get primaryCacheKey {
    if (userId == null) return null;
    return "$baseUrl$userId";
  }

  String get version => configContainer.get('version');

  // String? get baseUrl => configContainer.get('baseUrl');
  static String get baseUrl => "http://193.187.129.247";
  //
  // // "http://192.168.1.105:8000";
  //   "http://185.230.138.118:8001";

  Uri? get uri {
    return Uri.parse(baseUrl);
  }

  static Future set(String k, dynamic v) async {
    configContainer.put(k, v);
  }

  static Future clear() async {
    configContainer.clear();
  }

  static Future remove(String k) async {
    configContainer.delete(k);
  }
}
