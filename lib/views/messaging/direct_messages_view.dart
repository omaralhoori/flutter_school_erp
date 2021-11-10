import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/messaging/messaging_view.dart';
import 'package:school_erp/views/messaging/messaging_viewmodel.dart';

class DirectMessagesView extends StatefulWidget {
  const DirectMessagesView({Key? key}) : super(key: key);

  @override
  _DirectMessagesViewState createState() => _DirectMessagesViewState();
}

class _DirectMessagesViewState extends State<DirectMessagesView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<MessagingViewModel>(onModelReady: (model) async {
      await model.init();
    }, builder: (context, model, child) {
      Future<void> onrefresh() async {
        await model.getMessages();
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
            future: model.getMessages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: onrefresh,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: ListView.builder(
                      itemCount: model.messages.length,
                      itemBuilder: (context, index) {
                        int unreadMessage = 0;
                        for (var replay in model.messages[index].replies) {
                          if (replay.isAdministration == 1 &&
                              replay.isRead == 0) {
                            unreadMessage += 1;
                          }
                        }
                        return MessageGesture(
                          name: model.messages[index].name,
                          title: model.messages[index].title,
                          postTime: model.messages[index].creation,
                          message: model.messages[index].replies.isNotEmpty
                              ? model.messages[index].replies.last.message
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

class MessageGesture extends StatelessWidget {
  final String name;
  final String title;
  final String postTime;
  final String message;
  final bool isRead;
  final int unreadMessages;
  const MessageGesture({
    Key? key,
    required this.name,
    required this.title,
    required this.postTime,
    required this.message,
    required this.isRead,
    required this.unreadMessages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationHelper.push(
            context: context, page: MessagingView(name: this.name));
      },
      child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12)),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      message,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight:
                              isRead ? FontWeight.normal : FontWeight.bold),
                    ),
                  ],
                ))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Palette.postingTime(
                          DateTime.parse(postTime), context.locale.toString()),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isRead ? FontWeight.normal : FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    if (unreadMessages > 0)
                      Container(
                        width: 20,
                        height: 20,
                        child: Center(
                          child: Text(
                            unreadMessages.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red[600]),
                      )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
