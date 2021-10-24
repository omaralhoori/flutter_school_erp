import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/announcement.dart';
import 'package:school_erp/views/base_viewmodel.dart';
import 'package:school_erp/utils/dio_helper.dart';
import 'package:injectable/injectable.dart';

import '../../app/locator.dart';
import '../../services/api/api.dart';
import '../../model/offline_storage.dart';

@lazySingleton
class HomeViewModel extends BaseViewModel {
  List<Announcement> newsList = [];
  List<Album> albums = [];

  Future<bool> getAnnoucements() async {
    try {
      this.newsList = await locator<Api>().getAnnouncements();
      if (this.newsList.isNotEmpty)
        await OfflineStorage.putItem('allPosts', newsList);
    } catch (DioError) {
      var snapshot = await OfflineStorage.getItem('allPosts');
      this.newsList =
      snapshot["data"] is List<Announcement> ? snapshot["data"] : [];

      //.map<Announcement>((announcement) {
      //       return announcement;
      //     }).toList();
    }
    return Future.value(true);
  }


  Future<bool> getAlbums() async {
    try {
      this.albums = await locator<Api>().getGallery();
      if (this.albums.isNotEmpty) {
        await OfflineStorage.putItem('allAlbums', albums);
      }
    } catch (DioError) {
      var snapshot = await OfflineStorage.getItem('allAlbums');
      this.albums =
      snapshot["data"] is List<Album> ? snapshot["data"] : [];

      //.map<Announcement>((announcement) {
      //       return announcement;
      //     }).toList();
    }
    return Future.value(true);
  }
}
