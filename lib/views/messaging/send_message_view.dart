import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/form/controls/control.dart';
import 'package:school_erp/model/contact_message_request.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/utils/enums.dart';
import 'package:school_erp/utils/frappe_alert.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/messaging/direct_messages_view.dart';
import 'package:school_erp/views/messaging/messaging_viewmodel.dart';

import 'package:school_erp/widgets/frappe_button.dart';

class SendMessageView extends StatefulWidget {
  const SendMessageView({Key? key}) : super(key: key);

  @override
  _SendMessageViewState createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    return BaseView<MessagingViewModel>(
      builder: (context, model, _) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  backgroundColor: Palette.appbarBackgroundColor,
                  leading: BackButton(
                    color: Palette.appbarForegroundColor,
                  ),
                  title: Text(
                    tr('Send Message'),
                    style: TextStyle(color: Palette.appbarForegroundColor),
                  )),
              body: SizedBox.expand(
                child: Container(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          FormBuilder(
                            key: _fbKey,
                            child: Column(
                              children: [
                                buildDecoratedControl(
                                  control: FormBuilderTextField(
                                    name: 'title',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context),
                                    ]),
                                    decoration: Palette.formFieldDecoration(
                                      label: tr("Title"),
                                    ),
                                  ),
                                  field: DoctypeField(
                                      fieldname: "title", label: tr("Title")),
                                ),
                                buildDecoratedControl(
                                    control: FormBuilderTextField(
                                      name: 'message',
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      minLines: 5,
                                      maxLines: 5,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(context),
                                      ]),
                                      decoration: Palette.formFieldDecoration(
                                          hint: tr("Enter your message"),
                                          label: tr("Message"),
                                          fillColor: Color(0xEaFFFFFF)),
                                    ),
                                    field: DoctypeField(
                                        fieldname: "message",
                                        label: tr("Message"))),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  child: FrappeFlatButton(
                                      onPressed: () async {
                                        if (_fbKey.currentState != null) {
                                          if (_fbKey.currentState!
                                              .saveAndValidate()) {
                                            var formValue =
                                                _fbKey.currentState?.value;
                                            if (formValue == null) return;
                                            bool res =
                                                await model.sendParentMessage(
                                                    formValue["title"],
                                                    formValue["message"]);
                                            if (res) {
                                              FrappeAlert.successAlert(
                                                  title: tr(
                                                      "Message sent successfully"),
                                                  context: context);
                                              model.notify = true;
                                              await model.getDirectMessages();
                                              Navigator.pop(context);
                                            } else {
                                              FrappeAlert.errorAlert(
                                                  title: tr(
                                                      "Something went wrong"),
                                                  context: context);
                                            }
                                          }
                                        }
                                      },
                                      fullWidth: true,
                                      height: 40,
                                      buttonType: ButtonType.primary,
                                      title: tr("Send Message")),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
