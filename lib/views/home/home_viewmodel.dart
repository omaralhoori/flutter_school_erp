import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/contact_message_request.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/model/parent/parent.dart';
import 'package:school_erp/model/payment/parent_payment.dart';
import 'package:school_erp/storage/posts_storage.dart';
import 'package:school_erp/views/base_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:school_erp/widgets/home_widgets/gallery_tab.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../app/locator.dart';
import '../../services/api/api.dart';
import '../../storage/offline_storage.dart';

@lazySingleton
class HomeViewModel extends BaseViewModel {
  List<Content> contentList = [];
  List<Album> albums = [];
  List<Album> filteredAlbums = [];
  List<Album> parentAlbums = [];
  List<Album> filteredParentAlbums = [];

  List<String> branchList = [];
  List<String> sectionList = [];
  List<String> classList = [];

  List<RankModel> _branches = [];
  List<RankModel> _sections = [];
  List<RankModel> _classes = [];

  ParentPayment? parentPayment;
  Parent? parentData;
  int unreadDM = 0;
  int unreadGM = 0;

  bool _filterOn = false;
  bool get filterOn => _filterOn;
  set filterOn(bool val){
    this._filterOn = val;
    notifyListeners();
  }

  HomeViewModel() {
    getParentData();
    getAlbums().then((value) {
      _branches = List.generate(branchList.length, (index) => RankModel(text: branchList[index], isSelected: false));
      _sections = List.generate(sectionList.length, (index) => RankModel(text: sectionList[index], isSelected: false));
      _classes = List.generate(classList.length, (index) => RankModel(text: classList[index], isSelected: false));
    });
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
      getRankListItems(album);
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

  void getRankListItems(Album album) {
    if(album.branch != null) {
      if(!branchList.contains(album.branch)){
        branchList.add(album.branch!);
      }
    }
    if(album.section != null){
      if(!sectionList.contains(album.section)){
        sectionList.add(album.section!);
      }
    }
    if(album.classCode != null){
      if(!classList.contains(album.classCode)){
        classList.add(album.classCode!);
      }
    }
  }

  void setFilter(List<String> selectedBranches, List<String> selectedSections, List<String> selectedClasses) {
    filteredAlbums = albums.where((element) => selectedBranches.contains(element.branch) || selectedSections.contains(element.section) || selectedClasses.contains(element.classCode)).toList();
    filteredParentAlbums = parentAlbums.where((element) => selectedBranches.contains(element.branch) || selectedSections.contains(element.section) || selectedClasses.contains(element.classCode)).toList();
    filteredAlbums.forEach((element) {
      print("albums: ${element.branch}");
    });
    filteredParentAlbums.forEach((element) {
      print("parentAlbums: ${element.branch}");
    });
  }

  void showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(tr('Cancel')),
      onPressed:  () {
        filterOn = false;
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(tr('Confirm')),
      onPressed:  () {
        List<RankModel> selectedBranches = _branches.where((element) => element.isSelected).toList();
        List<RankModel> selectedSections = _sections.where((element) => element.isSelected).toList();
        List<RankModel> selectedClasses = _classes.where((element) => element.isSelected).toList();
        locator<HomeViewModel>().setFilter(
          List.generate(selectedBranches.length, (index) => selectedBranches[index].text),
          List.generate(selectedSections.length, (index) => selectedSections[index].text),
          List.generate(selectedClasses.length, (index) => selectedClasses[index].text),
        );
        filterOn = true;
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(tr('Filter')),
      content: SizedBox(
        height: 200.0,
        width: 280.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('Branch')),
              RankFilter(rankList: _branches,),
              Text(tr('Section: ')),
              RankFilter(rankList: _sections, split: true,),
              Text(tr('Class: ')),
              RankFilter(rankList: _classes,),
            ],
          ),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
class RankModel{
  final String text;
  bool isSelected;

  RankModel({
    required this.text,
    required this.isSelected,
  });


}