import 'package:flutter/material.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';
import 'package:school_erp/widgets/home_widgets/content_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContentTab extends StatefulWidget {
  ContentTab({Key? key}) : super(key: key);

  @override
  State<ContentTab> createState() => _ContentTabState();
}

class _ContentTabState extends State<ContentTab> {
  ScrollController _scrollController = new ScrollController();

  bool _scrollLock = false;

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
                  home.notifyContent = true;
                  home.contentList = [];
                  await home.getContent();
                  await home.getUnreadMessages();
                },
                child: ListView.separated(
                  addAutomaticKeepAlives: false,
                  controller: _scrollController
                    ..addListener(() async {
                      if (!_scrollLock) {
                        var triggerFetchMoreSize =
                            0.9 * _scrollController.position.maxScrollExtent;
                        if (_scrollController.position.pixels >
                            triggerFetchMoreSize) {
                          _scrollLock = true;
                          home.notifyContent = true;
                          await home.getContent();
                          _scrollLock = false;
                        }
                      }
                    }),
                  itemCount: home.contentList.length,
                  itemBuilder: (ctxt, index) {
                    return VisibilityDetector(
                      key: Key(index.toString()),
                      onVisibilityChanged: (VisibilityInfo info) =>
                          home.setViewInfo(info, index),
                      child: ContentCard(
                        index: index,
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
