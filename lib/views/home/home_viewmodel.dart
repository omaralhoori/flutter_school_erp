import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/contact_message_request.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/model/parent/parent.dart';
import 'package:school_erp/model/payment/parent_payment.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/storage/posts_storage.dart';
import 'package:school_erp/views/album_preview/album_preview_view.dart';
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
  List<Album> filteredAlbums = [];
  List<Album> parentAlbums = [];
  List<Album> filteredParentAlbums = [];

  List<String> branchList = [];
  List<String> classList = [];
  List<String> sectionList = [];

  List<RankModel> _branches = [];
  List<RankModel> _classes = [];
  List<RankModel> _sections = [];

  List<dynamic>? _offClasses = [];
  List<dynamic>? _offSections = [];

  ParentPayment? parentPayment;
  Parent? parentData;
  int unreadDM = 0;
  int unreadGM = 0;

  bool _isTeacherRegistered = false;
  bool get isTeacherRegistered => _isTeacherRegistered;
  set isTeacherRegistered(bool val) {
    this._isTeacherRegistered = val;
    notifyListeners();
  }

  bool _filterOn = false;
  bool get filterOn => _filterOn;
  set filterOn(bool val) {
    this._filterOn = val;
    notifyListeners();
  }

  Future<bool> loginTeacher(String pwd) async {
    try {
      bool isLogined = await locator<Api>().loginTeacher(pwd);
      isTeacherRegistered = isLogined;
      return isLogined;
    } catch (e) {
      return false;
    }
  }

  HomeViewModel() {
    getParentData().then((value) {
      getAlbums().then((value) async {
        getRankListItems();
        List<dynamic>? _offBranches =
            (await OfflineStorage.getItem("branches")['data']) ??
                (await locator<Api>().getSchoolBranches());
        _offClasses = (await OfflineStorage.getItem("classes")['data']) ??
            (await locator<Api>().getSchoolClasses());
        _offSections = (await OfflineStorage.getItem("sections")['data']) ??
            (await locator<Api>().getSchoolSections());
        Map<String, String> _mapBranches = {};
        _offBranches!.forEach((element) {
          _mapBranches[element['name']] = element['branch_name'];
        });
        _branches = List.generate(
          branchList.length,
          (index) => RankModel(
            code: branchList[index],
            text: _mapBranches[branchList[index]]!,
            rankType: RankType.Branch,
            isSelected: false,
          ),
        );
      });
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
      getParentAlbums();
    }
    return Future.value(true);
  }

  void getParentAlbums() {
    if (!Config().isGuest) {
      this.parentAlbums.clear();
      this.albums.forEach((album) {
        if (album.branch != null) {
          if (album.branch == this.parentData!.branchCode) {
            this.parentAlbums.add(album);
          }
        }
        if (album.classCode != null) {
          this.parentData!.students.forEach((student) {
            if (album.classCode == student.classCode) {
              this.parentAlbums.add(album);
            }
          });
        }
        if (album.section != null) {
          this.parentData!.students.forEach((student) {
            if (album.section! == student.sectionCode) {
              this.parentAlbums.add(album);
            }
          });
        }
      });

      this.parentAlbums.forEach((element) {
        this.albums.remove(element);
      });
    }
  }

  Future<bool> getContent() async {
    try {
      List<Content> _contents =
          await locator<Api>().getContents(this.contentList.length);
      if (_contents.isNotEmpty) {
        List<Content> filteredContents = _contents
            .where((element) => !(this.contentList.any((it) =>
                (it.name == element.name &&
                    it.contentType == element.contentType))))
            .toList();
        this.contentList = List.from(this.contentList)
          ..addAll(filteredContents);
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
      print(dioError);
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
    if (!Config().isGuest) {
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
    if (!Config().isGuest) {
      try {
        parentData = await locator<Api>().getParentData();
        var degreeSettings = await locator<Api>().getDegreeSettings();
        if (degreeSettings != null)
          OfflineStorage.putItem("degreeSettings", degreeSettings);
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
    }
    return true;
  }

  void getRankListItems() {
    albums.forEach((album) {
      if (album.branch != null) {
        if (!branchList.contains(album.branch)) {
          branchList.add(album.branch!);
        }
      }
    });
  }

  void setFilter(List<String> selectedBranches, List<String> selectedSections,
      List<String> selectedClasses) {
    if (selectedSections.isNotEmpty && selectedClasses.isNotEmpty) {
      filteredAlbums = albums
          .where((element) =>
              selectedBranches.contains(element.branch) &&
              selectedClasses.contains(element.classCode) &&
              selectedSections.contains(element.section!))
          .toList();
      filteredParentAlbums = parentAlbums
          .where((element) =>
              selectedBranches.contains(element.branch) &&
              selectedClasses.contains(element.classCode) &&
              selectedSections.contains(element.section!))
          .toList();
    } else if (selectedClasses.isNotEmpty) {
      filteredAlbums = albums
          .where((element) =>
              selectedBranches.contains(element.branch) &&
              selectedClasses.contains(element.classCode))
          .toList();
      filteredParentAlbums = parentAlbums
          .where((element) =>
              selectedBranches.contains(element.branch) &&
              selectedClasses.contains(element.classCode))
          .toList();
    } else {
      filteredAlbums = albums
          .where((element) => selectedBranches.contains(element.branch))
          .toList();
      filteredParentAlbums = parentAlbums
          .where((element) => selectedBranches.contains(element.branch))
          .toList();
    }
  }

  void showAlertDialog(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    Widget cancelButton = TextButton(
      child: Text(tr('Cancel')),
      onPressed: () {
        filterOn = false;
        _branches.forEach((element) {
          element.isSelected = false;
        });
        _sections.clear();
        _classes.clear();
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(tr('Confirm')),
      onPressed: () {
        List<RankModel> selectedBranches =
            _branches.where((element) => element.isSelected).toList();
        List<RankModel> selectedClasses =
            _classes.where((element) => element.isSelected).toList();
        List<RankModel> selectedSections =
            _sections.where((element) => element.isSelected).toList();
        if (selectedBranches.isEmpty) {
          _filterOn = false;
        } else {
          locator<HomeViewModel>().setFilter(
            List.generate(selectedBranches.length,
                (index) => selectedBranches[index].code),
            List.generate(selectedSections.length,
                (index) => selectedSections[index].code),
            List.generate(
                selectedClasses.length, (index) => selectedClasses[index].code),
          );
          filterOn = true;
        }
        Navigator.pop(context);
      },
    );
    Widget alert = StatefulBuilder(
      builder: (context, setState) {
        return WillPopScope(
          onWillPop: () async {
            filterOn = false;
            _branches.forEach((element) {
              element.isSelected = false;
            });
            _sections.clear();
            _classes.clear();
            return true;
          },
          child: AlertDialog(
            title: Text(tr('Filter')),
            content: SizedBox(
              height: size.height * .4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr('Branch')),
                    Wrap(
                      direction: Axis.horizontal,
                      children: List.generate(
                          _branches.length,
                          (i) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: _branches[i].isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        _branches[i].isSelected =
                                            !_branches[i].isSelected;
                                        filterChanged(_branches[i]);
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _branches[i].isSelected =
                                            !_branches[i].isSelected;
                                        filterChanged(_branches[i]);
                                      });
                                    },
                                    child: Text(
                                      _branches[i].text,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )),
                    ),
                    if (_classes.isNotEmpty) Text(tr('Class: ')),
                    if (_classes.isNotEmpty)
                      Wrap(
                        direction: Axis.horizontal,
                        children: List.generate(
                            _classes.length,
                            (i) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: _classes[i].isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          _classes[i].isSelected =
                                              !_classes[i].isSelected;
                                          filterChanged(_classes[i]);
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _classes[i].isSelected =
                                              !_classes[i].isSelected;
                                          filterChanged(_classes[i]);
                                        });
                                      },
                                      child: Text(_classes[i].text,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                )),
                      ),
                    if (_sections.isNotEmpty) Text(tr('Section: ')),
                    if (_sections.isNotEmpty)
                      Wrap(
                        direction: Axis.horizontal,
                        children: List.generate(
                            _sections.length,
                            (i) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: _sections[i].isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          _sections[i].isSelected =
                                              !_sections[i].isSelected;
                                          filterChanged(_sections[i]);
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _sections[i].isSelected =
                                              !_sections[i].isSelected;
                                          filterChanged(_sections[i]);
                                        });
                                      },
                                      child: Text(_sections[i].text,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                )),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              cancelButton,
              continueButton,
            ],
          ),
        );
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> filterChanged(RankModel rank) async {
    if (rank.rankType == RankType.Branch) {
      List<Album> a = [
        ...albums.where((element) => element.branch == rank.code).toList(),
        ...parentAlbums.where((element) => element.branch == rank.code).toList()
      ];
      a.forEach((album) {
        if (album.classCode != null) {
          if (!classList.contains(album.classCode) && rank.isSelected) {
            classList.add(album.classCode!);
          } else {
            classList.remove(album.classCode);
          }
        }
      });

      Map<String, String> _mapClasses = {};
      _offClasses!.forEach((element) {
        _mapClasses[element['name']] = element['class_name'];
      });
      _classes = List.generate(classList.length, (index) {
        return RankModel(
            code: classList[index],
            text: _mapClasses[classList[index]]!,
            rankType: RankType.Class,
            isSelected: false);
      });
    } else if (rank.rankType == RankType.Class) {
      List<Album> a = [
        ...albums.where((element) => element.classCode == rank.code).toList(),
        ...parentAlbums
            .where((element) => element.classCode == rank.code)
            .toList()
      ];
      a.forEach((album) {
        if (album.section != null) {
          if (!sectionList.contains(album.section!) && rank.isSelected) {
            sectionList.add(album.section!);
          } else {
            sectionList.remove(album.section!);
          }
        }
      });

      Map<String, String> _mapSections = {};
      _offSections!.forEach((element) {
        _mapSections[element['name']] = element['section_name'];
      });
      _sections = List.generate(
          sectionList.length,
          (index) => RankModel(
              code: sectionList[index],
              text: _mapSections[sectionList[index]]!,
              rankType: RankType.Section,
              isSelected: false));
    }
    bool branchEmpty =
        _branches.where((element) => element.isSelected).toList().isEmpty;
    if (branchEmpty) {
      _classes.clear();
      classList.clear();
      _sections.clear();
      sectionList.clear();
    }
    if (classList.isEmpty) {
      _sections.clear();
      sectionList.clear();
    }
  }
}

class RankModel {
  final String code;
  final String text;
  final RankType rankType;
  bool isSelected;

  RankModel({
    required this.code,
    required this.text,
    required this.rankType,
    required this.isSelected,
  });
}
