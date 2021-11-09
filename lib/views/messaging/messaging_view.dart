import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/messaging/message.dart';
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

  @override
  Widget build(BuildContext context) {
    return BaseView<MessagingViewModel>(onModelReady: (model) {
      message = model.getMessageByName(name);
    }, builder: (context, model, child) {
      return message != null
          ? Scaffold(
              appBar: AppBar(),
              body: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(message!.title)),
                              Text(Palette.postingTime(
                                  DateTime.parse(message!.creation),
                                  context.locale.toString())),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: message!.replies.length,
                    padding: EdgeInsets.only(top: 50, bottom: 10),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment:
                              (message!.replies[index].isAdministration == 1
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  (message!.replies[index].isAdministration == 1
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
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
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
                                    bool result = await model.addMessageReply(
                                        message!, reply);
                                    if (!result) {
                                      FrappeAlert.errorAlert(
                                          title: tr("The message was not sent"),
                                          context: context);
                                    } else {
                                      _fbKey.currentState!
                                          .patchValue({"message": ""});
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
                  ),
                ],
              ),
            )
          : Scaffold();
    });
  }
}
