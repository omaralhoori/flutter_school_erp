import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/views/base_viewmodel.dart';
import 'package:injectable/injectable.dart';

import '../../app/locator.dart';
import '../../services/api/api.dart';
import '../../model/offline_storage.dart';

@lazySingleton
class HomeViewModel extends BaseViewModel {
  List<Content> contentList = [];
  List<Album> albums = [];


  Future<bool> getAlbums() async {
    try {
      this.albums = await locator<Api>().getGallery();
      if (this.albums.isNotEmpty) {
        await OfflineStorage.putItem('allAlbums', albums);
      }
    } catch (dioError) {
      var snapshot = await OfflineStorage.getItem('allAlbums');
      this.albums =
      snapshot["data"] is List<Album> ? snapshot["data"] : [];
    }
    return Future.value(true);
  }

  Future<bool> getContent() async {
    try {
      this.contentList = await locator<Api>().getContents();
      if (this.contentList.isNotEmpty) {
        try{
          await OfflineStorage.putItem('allContents', contentList);
        }catch(e){
          print(e);
        }
      }
    } catch (dioError) {
      var snapshot = await OfflineStorage.getItem('allContents');
      this.contentList =
      snapshot["data"] is List<Album> ? snapshot["data"] : [];
    }
    return Future.value(true);
  }
}
