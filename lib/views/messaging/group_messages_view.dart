import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/messaging/direct_messages_view.dart';
import 'package:school_erp/views/messaging/messaging_viewmodel.dart';

class GroupMessagesView extends StatefulWidget {
  final String studentNo;
  const GroupMessagesView({Key? key, required this.studentNo})
      : super(key: key);

  @override
  _GroupMessagesViewState createState() => _GroupMessagesViewState(studentNo);
}

class _GroupMessagesViewState extends State<GroupMessagesView> {
  final String studentNo;

  _GroupMessagesViewState(this.studentNo);

  @override
  Widget build(BuildContext context) {
    return BaseView<MessagingViewModel>(onModelReady: (model) async {
      await model.init();
    }, builder: (context, model, child) {
      Future<void> onrefresh() async {
        await model.getGroupMessages(studentNo);
        setState(() {});
      }

      return Scaffold(
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
                return RefreshIndicator(
                  onRefresh: onrefresh,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: ListView.builder(
                      itemCount: model.groupMessages.length,
                      itemBuilder: (context, index) {
                        int unreadMessage = 0;
                        for (var replay in model.groupMessages[index].replies) {
                          if (replay.isAdministration == 1 &&
                              replay.isRead == 0) {
                            unreadMessage += 1;
                          }
                        }
                        return MessageGesture(
                          name: model.groupMessages[index].name,
                          title: model.groupMessages[index].title,
                          postTime: model.groupMessages[index].creation,
                          message: model.groupMessages[index].replies.isNotEmpty
                              ? model.groupMessages[index].replies.last.message
                              : "",
                          isRead: unreadMessage == 0,
                          unreadMessages: unreadMessage,
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      );
    });
  }
}
