import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:school_erp/config/frappe_palette.dart';
import 'package:school_erp/form/controls/control.dart';
import 'package:school_erp/model/config.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/model/login/login_request.dart';
import 'package:school_erp/model/login/login_response.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/views/home/home_view.dart';
import 'package:school_erp/widgets/frappe_bottom_sheet.dart';
import 'package:school_erp/model/common.dart';
import 'login_viewmodel.dart';

import '../../config/palette.dart';
import '../../widgets/frappe_button.dart';

import '../../views/base_view.dart';

import '../../utils/frappe_alert.dart';
import '../../utils/enums.dart';

import 'package:easy_localization/easy_localization.dart' as el;

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              FrappeLogo(),
              SizedBox(
                height: 24,
              ),
              Title(),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    FormBuilder(
                      key: _fbKey,
                      child: Column(
                        children: <Widget>[
                          /*
                          buildDecoratedControl(
                            control: FormBuilderTextField(
                              name: 'serverURL',
                              initialValue: model.savedCreds.serverURL,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.url(context),
                              ]),
                              decoration: Palette.formFieldDecoration(
                                label: tr("Server URL"),
                              ),
                            ),
                            field: DoctypeField(
                              fieldname: 'serverUrl',
                              label: tr("Server URL"),
                            ),
                          ),*/
                          buildDecoratedControl(
                            control: FormBuilderTextField(
                              name: 'usr',
                              initialValue: model.savedCreds.usr,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                              textDirection: TextDirection.ltr,
                              decoration: Palette.formFieldDecoration(
                                label: el.tr("Email Address"),
                              ),
                            ),
                            field: DoctypeField(
                                fieldname: "email",
                                label: el.tr("Email Address")),
                          ),
                          PasswordField(),
                          FrappeFlatButton(
                            title: el.tr('Login'), //model.loginButtonLabel,
                            fullWidth: true,
                            height: 46,
                            buttonType: ButtonType.primary,
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(
                                FocusNode(),
                              );

                              if (_fbKey.currentState != null) {
                                if (_fbKey.currentState!.saveAndValidate()) {
                                  var formValue = _fbKey.currentState?.value;

                                  try {
                                    // await setBaseUrl(formValue!["serverURL"]);

                                    var loginRequest = LoginRequest(
                                      usr: formValue!["usr"].trimRight(),
                                      pwd: formValue["pwd"],
                                    );

                                    var loginResponse = await model.login(
                                      loginRequest,
                                    );

                                    if (loginResponse.verification != null &&
                                        loginResponse.tmpId != null) {
                                      showModalBottomSheet(
                                        context: context,
                                        useRootNavigator: true,
                                        isScrollControlled: true,
                                        builder: (context) =>
                                            VerificationBottomSheetView(
                                          loginRequest: loginRequest,
                                          tmpId: loginResponse.tmpId!,
                                          message: loginResponse
                                              .verification!.prompt,
                                        ),
                                      );
                                    } else {
                                      Config.set('isGuest', false);
                                      NavigationHelper.clearAllAndNavigateTo(
                                        context: context,
                                        page: HomeView(),
                                      );
                                    }
                                  } on ErrorResponse catch (e) {
                                    if (e.statusCode ==
                                        HttpStatus.unauthorized) {
                                      FrappeAlert.errorAlert(
                                        title: "Not Authorized",
                                        subtitle: e.statusMessage,
                                        context: context,
                                      );
                                    } else {
                                      FrappeAlert.errorAlert(
                                        title: "Error",
                                        subtitle: e.statusMessage,
                                        context: context,
                                      );
                                    }
                                  } catch (e) {
                                    print("$e");
                                    FrappeAlert.errorAlert(
                                      title: "Error",
                                      subtitle: "Internal error occured!",
                                      context: context,
                                    );
                                  }
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () async {
                                  await context.setLocale(Locale('en'));
                                },
                                child: Text(
                                  "English",
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await context.setLocale(Locale('ar'));
                                },
                                child: Text(
                                  "العربية",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              TextButton(
                onPressed: () async {
                  String deviceID = await Palette.deviceID();
                  model.updateUserDetails(LoginResponse(userId: deviceID));
                  // print(Config().userId);
                  Config.set('isGuest', true);
                  NavigationHelper.clearAllAndNavigateTo(
                      context: context, page: HomeView());
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Palette.fontColorPrimary,
                    ),
                    Text(
                      el.tr("Skip"),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationBottomSheetView extends StatefulWidget {
  final String message;
  final String tmpId;
  final LoginRequest loginRequest;

  VerificationBottomSheetView({
    required this.message,
    required this.tmpId,
    required this.loginRequest,
  });

  @override
  _VerificationBottomSheetViewState createState() =>
      _VerificationBottomSheetViewState();
}

class _VerificationBottomSheetViewState
    extends State<VerificationBottomSheetView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      builder: (context, model, child) => AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: FractionallySizedBox(
          heightFactor: 0.4,
          child: FrappeBottomSheet(
            title: 'Verification',
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Text(widget.message),
                  SizedBox(
                    height: 10,
                  ),
                  FormBuilder(
                    key: _fbKey,
                    child: buildDecoratedControl(
                      control: FormBuilderTextField(
                        name: 'otp',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        decoration: Palette.formFieldDecoration(
                          label: "Verification",
                        ),
                      ),
                      field: DoctypeField(
                        fieldname: 'otp',
                        label: "Verification",
                      ),
                    ),
                  ),
                  FrappeFlatButton(
                    title: model.loginButtonLabel,
                    fullWidth: true,
                    height: 46,
                    buttonType: ButtonType.primary,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(
                        FocusNode(),
                      );

                      if (_fbKey.currentState != null) {
                        if (_fbKey.currentState!.saveAndValidate()) {
                          var formValue = _fbKey.currentState?.value;
                          widget.loginRequest.tmpId = widget.tmpId;
                          widget.loginRequest.otp = formValue!["otp"];
                          widget.loginRequest.cmd = "login";

                          try {
                            await model.login(widget.loginRequest);
                            Config.set('isGuest', true);
                            NavigationHelper.pushReplacement(
                              context: context,
                              page: HomeView(),
                            );
                          } catch (e) {
                            var _e = e as ErrorResponse;

                            if (_e.statusCode == HttpStatus.unauthorized) {
                              FrappeAlert.errorAlert(
                                title: "Not Authorized",
                                subtitle: _e.statusMessage,
                                context: context,
                              );
                            } else {
                              FrappeAlert.errorAlert(
                                title: "Error",
                                subtitle: _e.statusMessage,
                                context: context,
                              );
                            }
                          }
                        }
                      }
                    },
                  ),
                  Container(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Login to Frappe',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class FrappeLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('assets/frappe_icon.jpg'),
      width: 60,
      height: 60,
    );
  }
}

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return buildDecoratedControl(
      control: Stack(
        alignment: context.locale.toString() == 'ar'
            ? Alignment.centerLeft
            : Alignment.centerRight,
        children: [
          FormBuilderTextField(
            maxLines: 1,
            name: 'pwd',
            textDirection: TextDirection.ltr,
            textAlign: context.locale.toString() == 'ar'
                ? TextAlign.end
                : TextAlign.start,
            validator: FormBuilderValidators.compose([
              // FormBuilderValidators.required(context),
            ]),
            obscureText: _hidePassword,
            decoration: Palette.formFieldDecoration(
              label: el.tr("Password"),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
            ),
            child: Text(
              _hidePassword ? el.tr("Show") : el.tr("Hide"),
              style: TextStyle(
                color: FrappePalette.grey[600],
              ),
            ),
            onPressed: () {
              setState(
                () {
                  _hidePassword = !_hidePassword;
                },
              );
            },
          ),
        ],
      ),
      field: DoctypeField(fieldname: "password", label: el.tr("Password")),
    );
  }
}
