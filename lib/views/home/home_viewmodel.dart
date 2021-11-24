import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/contact_message_request.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/model/parent/parent.dart';
import 'package:school_erp/model/payment/parent_payment.dart';
import 'package:school_erp/storage/posts_storage.dart';
import 'package:school_erp/views/base_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../app/locator.dart';
import '../../services/api/api.dart';
import '../../storage/offline_storage.dart';

@lazySingleton
class HomeViewModel extends BaseViewModel {
  List<Content> contentList = [];
  List<Album> albums = [];
  List<Album> parentAlbums = [];
  ParentPayment? parentPayment;
  Parent? parentData;
  int unreadDM = 0;
  int unreadGM = 0;

  HomeViewModel() {
    getParentData();
  }

  Future<bool> getAlbums() async {
    try {
      this.albums = await locator<Api>().getGallery();
      getParentAlbums();
      if (this.albums.isNotEmpty) {
        await OfflineStorage.putItem('allAlbums', albums);
      }
      if (this.albums.isNotEmpty) {
        await OfflineStorage.putItem('parentAlbums', parentAlbums);
      }
    } catch (dioError) {
      print("DioError: $dioError");
      var snapshot = await OfflineStorage.getItem('allAlbums');
      if (snapshot["data"] is List) {
        Iterable i = snapshot["data"];
        this.albums = List.from(i.map((e) => e as Album));
      }
      var snapshotParent = await OfflineStorage.getItem('parentAlbums');
      if (snapshotParent["data"] is List) {
        Iterable i = snapshotParent["data"];
        this.parentAlbums = List.from(i.map((e) => e as Album));
      }
    }
    return Future.value(true);
  }

  void getParentAlbums() {
    this.parentAlbums.clear();
    this.albums.forEach((album) {
      if (album.section != null) {
        this.parentData!.students.forEach((student) {
          if (album.section!.split('-').last == student.sectionCode) {
            this.parentAlbums.add(album);
          }
        });
      } else if (album.classCode != null) {
        this.parentData!.students.forEach((student) {
          if (album.classCode == student.classCode) {
            this.parentAlbums.add(album);
          }
        });
      } else if (album.branch != null) {
        if (album.branch == this.parentData!.branchCode) {
          this.parentAlbums.add(album);
        }
      }
    });

    print(this.parentAlbums);
    this.parentAlbums.forEach((element) {
      this.albums.remove(element);
    });
  }

  Future<bool> getContent() async {
    try {
      List<Content> _contents =
          await locator<Api>().getContents(this.contentList.length);
      if (_contents.isNotEmpty) {
        this.contentList = List.from(this.contentList)..addAll(_contents);
        notifyListeners();
        if (this.contentList.isNotEmpty) {
          try {
            PostsStorage.putAllContents(this.contentList);
          } catch (e) {
            print(e);
          }
        }
      }
    } catch (dioError) {
      this.contentList = PostsStorage.getContents();
      // if (snapshot["data"] is List) {
      //   Iterable i = snapshot["data"];
      //   this.contentList = List.from(i.map((e) => e as Content));
      // }
      // = snapshot["data"];
      //snapshot["data"] is List<Content> ? snapshot["data"] : [];
    }
    return Future.value(true);
  }

  Future<void> setViewInfo(VisibilityInfo info, int index) async {
    if (index < contentList.length) {
      if (contentList[index].isViewed == 0) {
        try {
          locator<Api>().contentView(
              contentList[index].name, contentList[index].contentType);
          contentList[index].isViewed = 1;
        } catch (e) {}
      }
    }
  }

  Future likePost(String name, String type) async {
    try {
      locator<Api>().contentLike(name, type);
    } catch (e) {}
  }

  Future dislikePost(String name, String type) async {
    try {
      locator<Api>().contentDisLike(name, type);
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
    // parentData = await locator<Api>().getParentData();
    // OfflineStorage.putItem("parent", parentData);
    //parentData = OfflineStorage.getItem("parent")["data"] as Parent;
    try {
      parentData = await locator<Api>().getParentData();
      if (parentData == null) {
        parentData = OfflineStorage.getItem("parent")["data"] as Parent;
        return true;
      }
      try {
        OfflineStorage.putItem("parent", parentData);
      } catch (e) {
        print(e);
      }
    } catch (e) {
      try {
        parentData = OfflineStorage.getItem("parent")["data"] as Parent;
      } catch (e) {
        print(e);
      }
    }
    return true;
  }
}
