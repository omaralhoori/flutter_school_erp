import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/messaging/message.dart';
import 'package:school_erp/model/messaging/reply.dart';
import 'package:school_erp/utils/frappe_alert.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/messaging/messaging_viewmodel.dart';

class MessagingView extends StatefulWidget {
  final String name;
  const MessagingView({Key? key, required this.name}) : super(key: key);

  @override
  _MessagingViewState createState() => _MessagingViewState(name);
}

class _MessagingViewState extends State<MessagingView> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String name;
  Message? message;
  _MessagingViewState(this.name);
  int selectedNum = 0;
  List<bool> _selected = List.empty();
  @override
  Widget build(BuildContext context) {
    return BaseView<MessagingViewModel>(onModelReady: (model) {
      message = model.getMessageByName(name);
      if (message != null) {
        _selected = List.generate(message!.replies.length, (i) => false);
      }
    }, builder: (context, model, child) {
      return message != null
          ? Scaffold(
              appBar: AppBar(
                leading: selectedNum > 0
                    ? IconButton(
                        color: Palette.appbarForegroundColor,
                        onPressed: () {
                          setState(() {
                            _selected = List.generate(
                                message!.replies.length, (i) => false);
                            selectedNum = 0;
                          });
                        },
                        icon: Icon(Icons.cancel))
                    : BackButton(color: Palette.appbarForegroundColor),
                backgroundColor: Palette.appbarBackgroundColor,
                title: selectedNum > 0
                    ? Text(
                        '${selectedNum} ' + tr('selected'),
                        style: TextStyle(color: Palette.appbarForegroundColor),
                      )
                    : Text(""),
                actions: [
                  if (selectedNum > 0)
                    IconButton(
                      onPressed: () async {
                        Map<String, String> replies = Map();
                        String requestReplies = "";
                        _selected.asMap().forEach((index, value) => {
                              if (value)
                                {
                                  replies[message!.replies[index].name] = "",
                                  requestReplies +=
                                      "'" + message!.replies[index].name + "',"
                                }
                            });
                        if (requestReplies.length > 0)
                          requestReplies = requestReplies.substring(
                              0, requestReplies.length - 1);
                        bool res = await model.deleteReplies(
                            message!.name, requestReplies);
                        if (res) {
                          setState(() {
                            replies.forEach((key, value) {
                              message!.replies
                                  .removeWhere((reply) => reply.name == key);
                            });
                            _selected = List.generate(
                                message!.replies.length, (i) => false);
                            selectedNum = 0;
                          });
                        } else {
                          FrappeAlert.errorAlert(
                              title: tr("Something went wrong"),
                              context: context);
                        }
                      },
                      icon: Icon(Icons.delete),
                      color: Palette.appbarForegroundColor,
                    )
                ],
              ),
              body: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 20, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(child: Text(message!.title)),
                          Text(Palette.postingTime(
                              DateTime.parse(message!.creation),
                              context.locale.toString())),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        ListView.builder(
                          reverse: false,
                          itemCount: message!.replies.length,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                if (message!.replies[index].isAdministration ==
                                    0) {
                                  setState(() {
                                    _selected[index] = !_selected[index];
                                    _selected[index]
                                        ? selectedNum += 1
                                        : selectedNum -= 1;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: _selected[index]
                                        ? Colors.green[50]
                                        : null),
                                padding: EdgeInsets.only(
                                    left: 14, right: 14, top: 10, bottom: 10),
                                child: Align(
                                  alignment: (message!.replies[index]
                                              .isAdministration ==
                                          1
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (message!.replies[index]
                                                  .isAdministration ==
                                              1
                                          ? Colors.grey.shade200
                                          : Colors.blue[200]),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      message!.replies[index].message,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: FormBuilder(
                      key: _fbKey,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'message',
                              decoration: Palette.formFieldDecoration(
                                  label: tr("Message"),
                                  hint: tr("Write message...")),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            onPressed: () async {
                              if (_fbKey.currentState != null) {
                                if (_fbKey.currentState!.saveAndValidate()) {
                                  var formValue = _fbKey.currentState!.value;
                                  String reply = formValue["message"] ?? '';
                                  if (reply == '') return;
                                  String result = await model.addMessageReply(
                                      message!, reply);
                                  if (result == "") {
                                    FrappeAlert.errorAlert(
                                        title: tr("The message was not sent"),
                                        context: context);
                                  } else {
                                    _fbKey.currentState!
                                        .patchValue({"message": ""});
                                    Reply r = Reply(
                                        sendingDate: "",
                                        name: result,
                                        senderName: "",
                                        message: reply,
                                        isRead: 0,
                                        isAdministration: 0);
                                    setState(() {
                                      message!.replies.add(r);
                                      _selected.add(false);
                                    });
                                  }
                                }
                              }
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor: Palette.primaryButtonColor,
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Scaffold();
    });
  }
}
