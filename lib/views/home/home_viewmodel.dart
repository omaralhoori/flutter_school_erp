import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/contact_message_request.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/model/parent/parent.dart';
import 'package:school_erp/model/payment/parent_payment.dart';
import 'package:school_erp/views/base_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../app/locator.dart';
import '../../services/api/api.dart';
import '../../model/offline_storage.dart';

@lazySingleton
class HomeViewModel extends BaseViewModel {
  List<Content> contentList = [];
  List<Album> albums = [];
  ParentPayment? parentPayment;
  Parent? parentData;
  int unreadDM = 0;
  int unreadGM = 0;
  Future<bool> getAlbums() async {
    try {
      this.albums = await locator<Api>().getGallery();
      if (this.albums.isNotEmpty) {
        await OfflineStorage.putItem('allAlbums', albums);
      }
    } catch (dioError) {
      var snapshot = await OfflineStorage.getItem('allAlbums');
      this.albums = snapshot["data"] is List<Album> ? snapshot["data"] : [];
    }
    return Future.value(true);
  }

  Future<bool> getContent() async {
    try {
      this.contentList = await locator<Api>().getContents();
      if (this.contentList.isNotEmpty) {
        try {
          await OfflineStorage.putItem('allContents', contentList);
        } catch (e) {
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

  Future<void> setViewInfo(VisibilityInfo info, int index) async {
    if (index < contentList.length) {
      if (contentList[index].isViewed == 0) {
        try {
          locator<Api>().contentView(contentList[index]);
          contentList[index].isViewed = 1;
        } catch (e) {}
      }
    }
  }

  Future likePost(Content content) async {
    try {
      locator<Api>().contentLike(content);
    } catch (e) {}
  }

  Future dislikePost(Content content) async {
    try {
      locator<Api>().contentDisLike(content);
    } catch (e) {}
  }

  Future<void> getUnreadMessages() async {
    unreadDM = 0;
    unreadGM = 0;
    var messages = await locator<Api>().getUnreadMessages();
    for (var msg in messages) {
      if (msg["message_type"] != null) {
        if (msg["message_type"] == "School Direct Message") {
          unreadDM = msg["unread_messages"];
        } else if (msg["message_type"] == "School Group Message") {
          unreadGM = msg["unread_messages"];
        }
      }
    }
    notifyListeners();
  }

  Future<Map> sendContactMessage(ContactMessageRequest request) async {
    var response = await locator<Api>().sendContactMessage(request);
    return response;
  }

  Future<bool> getParentPayments() async {
    parentPayment = await locator<Api>().getParentPayments(null);
    return true;
  }

  Future<bool> getParentData() async {
    parentData = await locator<Api>().getParentData();
    return true;
  }
}
