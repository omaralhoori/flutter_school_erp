import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/model/parent/student.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/storage/offline_storage.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/degree/degree_view.dart';
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
            backgroundColor: Palette.appbarBackgroundColor,
            leading: BackButton(
              color: Palette.appbarForegroundColor,
            ),
            title: Text(
              tr("Student Information"),
              style: TextStyle(color: Palette.appbarForegroundColor),
            ),
          ),
          body: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/students_images/student_view_bg.png'),
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter)),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  child: Column(
                    children: [
                      StudentInfoCard(student: student),
                      Wrap(
                        children: [
                          StudentTool(
                            icon: Icons.mail,
                            title: tr("Messages"),
                            onTab: () {
                              NavigationHelper.push(
                                  context: context,
                                  page:
                                      GroupMessagesView(studentNo: student.no));
                            },
                            backgroundColor: Colors.purple.shade100,
                          ),
                          StudentTool(
                            icon: Icons.payments_outlined,
                            title: tr("Payments"),
                            onTab: () {
                              NavigationHelper.push(
                                  context: context,
                                  page: StudentPaymentView(
                                      studentNo: student.no));
                            },
                          ),
                          if (renderDegreesTool(student.no))
                            StudentTool(
                              icon: FontAwesomeIcons.graduationCap,
                              backgroundColor: Colors.redAccent.shade100,
                              title: tr("Degrees"),
                              onTab: () {
                                NavigationHelper.push(
                                    context: context,
                                    page: DegreeView(student: student));
                              },
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }
}

bool renderDegreesTool(String studentNo) {
  var degreeSettings = OfflineStorage.getItem("degreeSettings")["data"];
  bool render = false;
  if (degreeSettings != null) {
    for (var student in degreeSettings["students"]) {
      if (studentNo == student["student_no"]) {
        if (student["degree_report"] == 1) render = true;
        break;
      }
    }
  }

  return render;
}

class StudentInfoCard extends StatelessWidget {
  const StudentInfoCard({
    Key? key,
    required this.student,
  }) : super(key: key);

  final Student student;

  @override
  Widget build(BuildContext context) {
    String gender = student.gender == 'Female' ? 'g' : 'b';
    int photoNum = int.parse(student.no) % 4 + 1;
    bool isRtl = context.locale.languageCode == "ar";
    String direction = isRtl ? 'r' : '';
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade100, //Palette.studentCardBackgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, 10))
        ],
        image: DecorationImage(
            fit: BoxFit.contain,
            alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
            image: AssetImage(
                'assets/students_images/$gender$photoNum$direction.png')),
      ),
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
          // SizedBox(
          //   height: 16,
          //   child: Container(
          //     child: Container(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 20),
          //       decoration: BoxDecoration(
          //           border: Border(
          //               bottom:
          //                   BorderSide(color: Colors.black26))),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
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
            Flexible(
              child: Text(
                value,
              ),
            )
          ],
        ),
      ],
    );
  }
}
