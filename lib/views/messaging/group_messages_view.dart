import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/home/home_view.dart';
import 'package:school_erp/views/messaging/direct_messages_view.dart';
import 'package:school_erp/views/messaging/messaging_viewmodel.dart';

import '../../utils/navigation_helper.dart';

class GroupMessagesView extends StatefulWidget {
  final String studentNo;
  final isDirected;
  const GroupMessagesView(
      {Key? key, required this.studentNo, this.isDirected = false})
      : super(key: key);

  @override
  _GroupMessagesViewState createState() => _GroupMessagesViewState(studentNo);
}

class _GroupMessagesViewState extends State<GroupMessagesView> {
  final String studentNo;
  Future<bool> _onBackPressed() async {
    if (widget.isDirected) {
      NavigationHelper.pushReplacement(context: context, page: HomeView());
      return false;
    } else {
      return true;
    }
  }

  _GroupMessagesViewState(this.studentNo);

  @override
  Widget build(BuildContext context) {
    return BaseView<MessagingViewModel>(onModelReady: (model) async {
      await model.init();
    }, builder: (context, model, child) {
      Future<void> onrefresh() async {
        await model.getGroupMessages(studentNo);
      }

      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              tr("Messages"),
              style: TextStyle(color: Palette.appbarForegroundColor),
            ),
            leading: BackButton(color: Palette.appbarForegroundColor),
            backgroundColor: Palette.appbarBackgroundColor,
          ),
          body: FutureBuilder(
              future: model.getGroupMessages(studentNo),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MessagesRefresh(
                      onRefresh: onrefresh, messages: model.groupMessages);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      );
    });
  }
}
