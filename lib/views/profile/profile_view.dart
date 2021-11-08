import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/form/controls/control.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/model/update_profile_response.dart';
import 'package:school_erp/model/user_data.dart';
import 'package:school_erp/utils/enums.dart';
import 'package:school_erp/utils/frappe_alert.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/login/login_view.dart';
import 'package:school_erp/views/profile/profile_viewmodel.dart';
import 'package:school_erp/widgets/frappe_button.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(onModelReady: (model) async {
      await model.init();
      _fbKey.currentState!
          .patchValue({'fullname': model.fullName, 'email': model.email});
    }, builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            tr("Profile"),
            style: TextStyle(color: Palette.appbarForegroundColor),
          ),
          leading: BackButton(color: Palette.appbarForegroundColor),
          backgroundColor: Palette.appbarBackgroundColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            child: FormBuilder(
              key: _fbKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  buildDecoratedControl(
                    control: FormBuilderTextField(
                      name: 'fullname',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      initialValue: model.fullName,
                      // controller: TextEditingController.fromValue(
                      //     TextEditingValue(text: model.fullName)),
                      decoration: Palette.formFieldDecoration(
                        label: tr("Full Name"),
                      ),
                    ),
                    field: DoctypeField(
                        fieldname: "fullname", label: tr("Full Name")),
                  ),
                  buildDecoratedControl(
                    control: FormBuilderTextField(
                      name: 'email',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      initialValue: model.email,
                      // controller: TextEditingController.fromValue(
                      //     TextEditingValue(text: model.email)),
                      decoration: Palette.formFieldDecoration(
                        label: tr("Email Address"),
                      ),
                    ),
                    field: DoctypeField(
                        fieldname: "email", label: tr("Email Address")),
                  ),
                  PasswordField(),
                  FrappeFlatButton(
                    title: tr('Update'), //model.loginButtonLabel,
                    fullWidth: true,
                    height: 40,
                    buttonType: ButtonType.primary,
                    onPressed: () async {
                      // FocusScope.of(context).requestFocus(
                      //   FocusNode(),
                      // );
                      if (_fbKey.currentState != null) {
                        if (_fbKey.currentState!.saveAndValidate()) {
                          var formValue = _fbKey.currentState?.value;
                          String? pwd = formValue!["pwd"];
                          if (pwd != null &&
                              (pwd.length > 0 && pwd.length < 8)) {
                            FrappeAlert.errorAlert(
                              title: tr("Validation error"),
                              subtitle: tr(
                                  "Password must be greater than or equal to 8"),
                              context: context,
                            );
                            return;
                          }
                          try {
                            UserData userData = UserData(
                                fullName: formValue["fullname"],
                                email: formValue["email"].trimRight());
                            if (pwd != null) userData.password = pwd;
                            UpdateProfileResponse response =
                                await model.updateProfileData(userData);
                            if (response.errorMessage != null) {
                              FrappeAlert.errorAlert(
                                title: tr("Error"),
                                subtitle: tr(response.errorMessage!),
                                context: context,
                              );
                              return;
                            }
                            FrappeAlert.successAlert(
                                title: tr("Profile updated successfully"),
                                context: context);
                          } catch (e) {
                            FrappeAlert.errorAlert(
                              title: tr("Error"),
                              subtitle: tr("Internal error occurred!"),
                              context: context,
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
