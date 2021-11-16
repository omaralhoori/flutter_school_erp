import 'package:flutter/material.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';
import 'package:school_erp/widgets/home_widgets/content_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContentTab extends StatelessWidget {
  ContentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (context, home, _) {
        return FutureBuilder(
          future: home.getContent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: () async {
                  home.getContent();
                  home.getUnreadMessages();
                },
                child: ListView.separated(
                  itemCount: home.contentList.length,
                  itemBuilder: (ctxt, index) {
                    return VisibilityDetector(
                      key: Key(index.toString()),
                      onVisibilityChanged: (VisibilityInfo info) =>
                          home.setViewInfo(info, index),
                      child: ContentCard(
                        content: home.contentList[index],
                      ),
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
