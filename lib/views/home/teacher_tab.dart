import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/utils/enums.dart';
import 'package:school_erp/utils/frappe_alert.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';
import 'package:school_erp/views/login/login_view.dart';
import 'package:school_erp/views/student/student_view.dart';
import 'package:school_erp/widgets/frappe_button.dart';

class TeacherTab extends StatelessWidget {
  final bool isTeacherRegistered;
  const TeacherTab({Key? key, required this.isTeacherRegistered})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    return Container(
      padding: EdgeInsets.all(20),
      child: isTeacherRegistered
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      StudentTool(
                        icon: Icons.payment,
                        title: tr("Salary"),
                        onTab: () {},
                      ),
                      StudentTool(
                        icon: Icons.work_outline,
                        title: tr("Vacation"),
                        onTab: () {},
                        backgroundColor: Colors.green.shade100,
                      ),
                      StudentTool(
                        icon: Icons.mail_outline,
                        title: tr("Messages"),
                        onTab: () {},
                        backgroundColor: Colors.blue.shade100,
                      ),
                      StudentTool(
                        icon: Icons.settings_outlined,
                        title: tr("Settings"),
                        onTab: () {},
                        backgroundColor: Colors.red.shade100,
                      ),
                    ],
                  ),
                ],
              ),
            )
          : FormBuilder(
              key: _fbKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PasswordField(),
                  FrappeFlatButton(
                    onPressed: () async {
                      if (_fbKey.currentState != null) {
                        if (_fbKey.currentState!.saveAndValidate()) {
                          var formValue = _fbKey.currentState?.value;
                          bool isLogined = await locator<HomeViewModel>()
                              .loginTeacher(formValue!["pwd"] ?? '');
                          if (!isLogined) {
                            FrappeAlert.errorAlert(
                                title: tr("Password is not correct!"),
                                context: context);
                          }
                        }
                      }
                    },
                    buttonType: ButtonType.primary,
                    title: tr("Login"),
                  )
                ],
              ),
            ),
    );
  }
}
