import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/form/controls/control.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/model/update_profile_response.dart';
import 'package:school_erp/model/user_data.dart';
import 'package:school_erp/storage/config.dart';
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
            child: Column(
              children: [
                Center(
                  child: ProfileImagePicker(
                    uploadFunction: model.uploadUserPorfileImage,
                    imageUrl: model.profileImage,
                  ),
                ),
                FormBuilder(
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
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ProfileImagePicker extends StatefulWidget {
  ProfileImagePicker({Key? key, required this.uploadFunction, this.imageUrl})
      : super(key: key);
  final Future<String?> Function(XFile) uploadFunction;
  String? imageUrl;

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        XFile? file = await showImageSource(context);
        if (file != null) {
          String? url = await widget.uploadFunction(file);
          if (url != null) {
            setState(() {
              widget.imageUrl = url;
            });
          }
        }
      },
      child: Stack(
        children: [
          ClipOval(
            clipBehavior: Clip.hardEdge,
            child: (widget.imageUrl == null || widget.imageUrl == "")
                ? Image(
                    width: 160,
                    height: 160,
                    image: AssetImage('assets/user-avatar.png'),
                  )
                : CachedNetworkImage(
                    imageUrl: Config.baseUrl + widget.imageUrl!,
                    width: 160,
                    height: 160,
                  ),
          ),
          Positioned(
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Palette.primaryButtonColor),
              child: Icon(
                Icons.camera_enhance,
                color: Colors.white,
              ),
            ),
            right: 10,
            bottom: 10,
          )
        ],
      ),
    );
  }
}

Future<XFile?> showImageSource(BuildContext context) async {
  final ImagePicker _picker = ImagePicker();
  if (Platform.isIOS) {
    return showCupertinoModalPopup<XFile>(
        context: context,
        builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () async => Navigator.of(context).pop(
                        await _picker.pickImage(source: ImageSource.camera)),
                    child: Text(tr("Camera"))),
                CupertinoActionSheetAction(
                    onPressed: () async => Navigator.of(context).pop(
                        await _picker.pickImage(source: ImageSource.gallery)),
                    child: Text(tr("Gallery")))
              ],
            ));
  } else {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text(tr("Camera")),
                    onTap: () async => Navigator.of(context).pop(
                        await _picker.pickImage(source: ImageSource.camera))),
                ListTile(
                    leading: Icon(Icons.image),
                    title: Text(tr("Gallery")),
                    onTap: () async => Navigator.of(context).pop(
                        await _picker.pickImage(source: ImageSource.gallery))),
              ],
            ));
  }
}
