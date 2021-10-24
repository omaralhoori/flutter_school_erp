import 'package:flutter/material.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';

import 'announcement_card.dart';

class NewsTab extends StatelessWidget {
  NewsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BaseView<HomeViewModel>(
      builder: (context, home, _){
        return FutureBuilder(
          future: home.getAnnoucements(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: home.getAnnoucements,
                child: ListView.separated(
                    itemCount: home.newsList.length,
                    itemBuilder: (ctxt, index) {
                      return AnnouncementCard(
                        announcement: home.newsList[index],
                      );
                    },
                  separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                  },
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}