import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/l10n/messages_ar.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/messaging/message.dart';
import 'package:school_erp/storage/config.dart';
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
            future: model.getDirectMessages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MessagesRefresh(
                  onRefresh: model.getDirectMessages,
                  messages: model.directMessages,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      );
    });
  }
}

class MessagesRefresh extends StatefulWidget {
  const MessagesRefresh(
      {Key? key, required this.onRefresh, required this.messages})
      : super(key: key);
  final List<Message> messages;
  final Future Function() onRefresh;
  @override
  _MessagesRefreshState createState() => _MessagesRefreshState();
}

class _MessagesRefreshState extends State<MessagesRefresh> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.onRefresh();
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
        child: ListView.builder(
          itemCount: widget.messages.length,
          itemBuilder: (context, index) {
            int unreadMessage = 0;
            for (var replay in widget.messages[index].replies) {
              if (replay.isAdministration == 1 && replay.isRead == 0) {
                unreadMessage += 1;
              }
            }
            return MessageGesture(
              name: widget.messages[index].name,
              title: widget.messages[index].title,
              postTime: widget.messages[index].creation,
              message: widget.messages[index].replies.isNotEmpty
                  ? widget.messages[index].replies.last.message
                  : "",
              isRead: unreadMessage == 0,
              unreadMessages: unreadMessage,
              thumbnail: widget.messages[index].thumbnail,
            );
          },
        ),
      ),
    );
  }
}

class MessageGesture extends StatelessWidget {
  final String name;
  final String title;
  final String postTime;
  final String message;
  final String? thumbnail;
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
    this.thumbnail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int imageNum = random.nextInt(7) + 1;
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
                Container(
                  margin: context.locale.languageCode == 'ar'
                      ? EdgeInsets.only(left: 10)
                      : EdgeInsets.only(right: 10),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: (thumbnail == null || thumbnail == "")
                        ? Image(
                            image: AssetImage(
                                'assets/message_thumbnails/$imageNum.png'))
                        : CachedNetworkImage(
                            imageUrl: Config.baseUrl + thumbnail!),
                  ),
                ),
                Expanded(
                    child: Container(
                        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      message,
                      overflow: TextOverflow.ellipsis,
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
