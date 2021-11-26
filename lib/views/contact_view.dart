import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/form/controls/control.dart';
import 'package:school_erp/model/contact_message_request.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/utils/enums.dart';
import 'package:school_erp/utils/frappe_alert.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';

import '../widgets/frappe_button.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    return BaseView<HomeViewModel>(
      builder: (context, home, _) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/contact_bg.png'),
                      alignment: Alignment.bottomCenter)),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  backgroundColor: Palette.appbarBackgroundColor,
                  leading: BackButton(
                    color: Palette.appbarForegroundColor,
                  ),
                  title: Text(
                    tr('Contact Us'),
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
                                    name: 'sender_name',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context),
                                    ]),
                                    decoration: Palette.formFieldDecoration(
                                      label: tr("Sender Name"),
                                    ),
                                  ),
                                  field: DoctypeField(
                                      fieldname: "sender_name",
                                      label: tr("Sender Name")),
                                ),
                                buildDecoratedControl(
                                  control: FormBuilderTextField(
                                    name: 'email',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context),
                                      FormBuilderValidators.email(context)
                                    ]),
                                    decoration: Palette.formFieldDecoration(
                                      label: tr("Email Address"),
                                    ),
                                  ),
                                  field: DoctypeField(
                                      fieldname: "email",
                                      label: tr("Email Address")),
                                ),
                                buildDecoratedControl(
                                  control: FormBuilderTextField(
                                    name: 'subject',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context),
                                    ]),
                                    decoration: Palette.formFieldDecoration(
                                      label: tr("Subject"),
                                    ),
                                  ),
                                  field: DoctypeField(
                                      fieldname: "subject",
                                      label: tr("Subject")),
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
                                            String deviceId =
                                                await Palette.deviceID();
                                            ContactMessageRequest request =
                                                ContactMessageRequest(
                                                    senderName: formValue[
                                                        "sender_name"],
                                                    email: formValue["email"],
                                                    subject:
                                                        formValue["subject"],
                                                    message:
                                                        formValue["message"],
                                                    user: deviceId);
                                            var response = await home
                                                .sendContactMessage(request);
                                            if (response["message"] != null) {
                                              FrappeAlert.successAlert(
                                                  title:
                                                      tr(response["message"]),
                                                  context: context);
                                              setState(() {
                                                _fbKey.currentState!
                                                    .patchValue({
                                                  "sender_name": "",
                                                  "email": "",
                                                  "subject": "",
                                                  "message": "",
                                                });
                                              });
                                            } else if (response[
                                                    "errorMessage"] !=
                                                null) {
                                              FrappeAlert.errorAlert(
                                                  title: tr(
                                                      response["errorMessage"]),
                                                  context: context);
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
