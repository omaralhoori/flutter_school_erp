import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/model/post_version.dart';
import 'package:school_erp/services/api/api.dart';
import 'package:school_erp/storage/post_version_storage.dart';
import 'package:school_erp/storage/posts_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class StorageService {
  Box getHiveBox(String name) {
    return Hive.box(name);
  }

  Future<Box> initHiveBox(String name) {
    return Hive.openBox(name);
  }

  void registerAdapter<T>(TypeAdapter<T> adapter) {
    return Hive.registerAdapter<T>(adapter);
  }

  Future initHiveStorage() {
    return Hive.initFlutter();
  }

  putSharedPrefBoolValue(String key, bool value) async {
    var _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool(key, value);
  }

  Future<bool?> getSharedPrefBoolValue(String key) async {
    var _prefs = await SharedPreferences.getInstance();
    await _prefs.reload();
    return _prefs.getBool(key);
  }

  Future<void> checkPostVersions() async {
    List<PostVersion>? versions = await locator<Api>().getContentVersions();
    if (versions != null) {
      List<PostVersion> storedVersions = PostVersionStorage.getVersions();
      Future.forEach(storedVersions, (PostVersion sv) async {
        for (PostVersion v in versions) {
          if (v.name == sv.name) {
            try {
              if (v.version > sv.version) {
                Content? content;
                if (v.type == "News")
                  content = await locator<Api>().getNews(v.name);
                else if (v.type == "Announcement")
                  content = await locator<Api>().getAnnouncement(v.name);
                if (content != null) {
                  PostsStorage.putContent(content);
                }
              }
            } catch (e) {
              print(e);
            }

            return;
          }
        }
        try {
          PostsStorage.removeItem(sv.type, sv.name);
        } catch (e) {
          print(e);
        }
      });
      await PostVersionStorage.deleteVersions();
      PostVersionStorage.putAllVersions(versions);
    }
  }
}
