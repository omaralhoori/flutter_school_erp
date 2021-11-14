import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/adapters/student.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/messaging/group_messages_view.dart';
import 'package:school_erp/views/payment/student_payment_view.dart';
import 'package:school_erp/views/student/student_viewmodel.dart';

class StudentView extends StatefulWidget {
  const StudentView({Key? key, required this.student}) : super(key: key);
  final Student student;
  @override
  _StudentViewState createState() => _StudentViewState(student: student);
}

class _StudentViewState extends State<StudentView> {
  final Student student;
  _StudentViewState({required this.student});
  @override
  Widget build(BuildContext context) {
    return BaseView<StudentViewModel>(builder: (context, model, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              tr("Student Information"),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              child: Column(
                children: [
                  StudentInfo(
                    label: tr("No: "),
                    value: student.no,
                  ),
                  StudentInfo(
                    label: tr("Name: "),
                    value: student.name,
                  ),
                  StudentInfo(
                    label: tr("Class: "),
                    value: student.classCode + ' - ' + student.className,
                  ),
                  StudentInfo(
                    label: tr("Section: "),
                    value: student.sectionCode + ' - ' + student.sectionName,
                  ),
                  SizedBox(
                    height: 16,
                    child: Container(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black26))),
                      ),
                    ),
                  ),
                  Wrap(
                    children: [
                      StudentTool(
                        icon: Icons.mail,
                        title: tr("Messages"),
                        onTab: () {
                          NavigationHelper.push(
                              context: context,
                              page: GroupMessagesView(studentNo: student.no));
                        },
                        backgroundColor: Colors.purple.shade100,
                      ),
                      StudentTool(
                        icon: Icons.payments_outlined,
                        title: tr("Payments"),
                        onTab: () {
                          NavigationHelper.push(
                              context: context,
                              page: StudentPaymentView(studentNo: student.no));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));
    });
  }
}

class StudentTool extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTab;
  final Color? backgroundColor;
  StudentTool({
    required this.icon,
    required this.title,
    required this.onTab,
    this.backgroundColor = const Color(0xFFFFF5D9),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTab();
      },
      child: Container(
        height: 100,
        width: 100,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10, offset: Offset(0, 10))
            ]),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(
              height: 12,
            ),
            Text(title)
          ],
        ),
      ),
    );
  }
}

class StudentInfo extends StatelessWidget {
  const StudentInfo({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(value)
          ],
        ),
      ],
    );
  }
}
