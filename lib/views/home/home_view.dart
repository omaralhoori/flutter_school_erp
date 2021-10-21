import 'package:flutter/material.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/model/models.dart';
import 'package:school_erp/model/offline_storage.dart';
import 'package:school_erp/services/api/api.dart';
import 'package:school_erp/widgets/widgets.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Announcement> announcementList = [];

  Future<bool> getAnnoucements() async {
    try {
      this.announcementList = await locator<Api>().getAnnouncements();
      if (this.announcementList.isNotEmpty)
        await OfflineStorage.putItem('allPosts', announcementList);
    } catch (DioError) {
      var snapshot = await OfflineStorage.getItem('allPosts');
      this.announcementList =
      snapshot["data"] is List<Announcement> ? snapshot["data"] : [];

      //.map<Announcement>((announcement) {
      //       return announcement;
      //     }).toList();
    }
    return Future.value(true);
  }

  Future<void> updateData() async {
    try {
      this.announcementList = await locator<Api>().getAnnouncements();
      if (this.announcementList.isNotEmpty)
        await OfflineStorage.putItem('allPosts', announcementList);
    } catch (DioError) {
      var snapshot = await OfflineStorage.getItem('allPosts');
      this.announcementList =
      snapshot["data"] is List<Announcement> ? snapshot["data"] : [];

      //.map<Announcement>((announcement) {
      //       return announcement;
      //     }).toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
            child: FutureBuilder(
              future: getAnnoucements(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text("aa"),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: updateData,
                          child: ListView.builder(
                              itemCount: this.announcementList.length,
                              itemBuilder: (ctxt, index) {
                                return AnnouncementCard(
                                  announcement: this.announcementList[index],
                                );
                              }),
                        ),
                      )
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
      ),
    );
  }
}