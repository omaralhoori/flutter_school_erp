import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/form/controls/control.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/model/parent/parent.dart';
import 'package:school_erp/model/parent/student.dart';
import 'package:school_erp/services/api/api.dart';
import 'package:school_erp/storage/offline_storage.dart';
import 'package:school_erp/utils/enums.dart';
import 'package:school_erp/utils/frappe_alert.dart';
import 'package:school_erp/widgets/frappe_button.dart';
import 'package:school_erp/widgets/payment_widgets.dart';

class DegreeView extends StatefulWidget {
  const DegreeView({Key? key, required this.student}) : super(key: key);
  final Student student;
  @override
  _DegreeViewState createState() => _DegreeViewState(student: student);
}

class _DegreeViewState extends State<DegreeView> {
  final Student student;
  List<FormBuilderFieldOption> semesterOptions = getSemesterFormOptions();
  List<FormBuilderFieldOption> periodOptions = getPeriodFormOptions();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  _DegreeViewState({required this.student});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr("Degrees"),
          style: TextStyle(color: Palette.appbarForegroundColor),
        ),
        backgroundColor: Palette.appbarBackgroundColor,
        leading: BackButton(
          color: Palette.appbarForegroundColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            FormBuilder(
                key: _fbKey,
                child: Column(
                  children: [
                    buildDecoratedControl(
                      control: FormBuilderRadioGroup(
                          options: semesterOptions,
                          name: 'semesters',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          onChanged: (dynamic value) {
                            setState(() {
                              periodOptions =
                                  getPeriodFormOptions(semester: value);
                            });
                          },
                          decoration: Palette.formFieldDecoration(
                            label: tr("Semesters"),
                          )),
                      field: DoctypeField(
                          fieldname: "semesters", label: tr("Semesters")),
                    ),
                    buildDecoratedControl(
                      control: FormBuilderRadioGroup(
                          options: periodOptions,
                          name: 'periods',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          decoration: Palette.formFieldDecoration(
                            label: tr("Periods"),
                          )),
                      field: DoctypeField(
                          fieldname: "periods", label: tr("Periods")),
                    ),
                    buildDecoratedControl(
                      control: FormBuilderRadioGroup(
                          options: [
                            FormBuilderFieldOption(
                              value: tr("Arabic"),
                            ),
                            FormBuilderFieldOption(
                              value: tr("English"),
                            ),
                          ],
                          name: 'language',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          decoration: Palette.formFieldDecoration(
                            label: tr("Language"),
                          )),
                      field: DoctypeField(
                          fieldname: "language", label: tr("Language")),
                    ),
                    FrappeFlatButton(
                      title: tr('Download'), //model.loginButtonLabel,
                      fullWidth: true,
                      height: 46,
                      buttonType: ButtonType.primary,
                      onPressed: () async {
                        if (_fbKey.currentState != null) {
                          if (_fbKey.currentState!.saveAndValidate()) {
                            var formValue = _fbKey.currentState?.value;
                            Parent parentData =
                                OfflineStorage.getItem("parent")["data"]
                                    as Parent;
                            if (formValue == null || parentData == null) {
                              return FrappeAlert.errorAlert(
                                title: tr("Missing data"),
                                subtitle: tr("Something went wrong!"),
                                context: context,
                              );
                            }

                            String semester =
                                getSemester(formValue['semesters']);
                            String period = getPeriod(formValue['periods']);
                            String allPeriods = period == "9" ? "1" : "0";
                            var report = getLanguage(
                                formValue['language'], semester, period);
                            locator<Api>().downloadDegreesPdf(
                                report: report,
                                currentYear: parentData.yearName.split("/")[0],
                                allPeriods: allPeriods,
                                classNo: widget.student.classCode,
                                divisionNo: widget.student.sectionCode,
                                branchNo: parentData.branchCode,
                                period: allPeriods == "0" ? period : "1",
                                semester: semester,
                                contractNo: parentData.contractNo,
                                studentNo: student.no);
                          }
                        }
                      },
                    ),
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}

List<FormBuilderFieldOption> getSemesterFormOptions() {
  List<FormBuilderFieldOption> options = [];
  var degreeSettings = OfflineStorage.getItem("degreeSettings")["data"];
  bool allSemesters = true;
  if (degreeSettings != null) {
    if (degreeSettings["first_semester"] != null &&
        degreeSettings["first_semester"]["first_semester"] == 1)
      options.add(FormBuilderFieldOption(
        value: tr("First Semester"),
      ));
    else
      allSemesters = false;
    if (degreeSettings["second_semester"] != null &&
        degreeSettings["second_semester"]["second_semester"] == 1)
      options.add(FormBuilderFieldOption(
        value: tr("Second Semester"),
      ));
    else
      allSemesters = false;
  } else
    allSemesters = false;
  if (allSemesters) {
    options.add(FormBuilderFieldOption(
      value: tr("All Semesters"),
    ));
  }
  return options;
}

List<FormBuilderFieldOption> getPeriodFormOptions({dynamic semester}) {
  List<FormBuilderFieldOption> options = [];
  var degreeSettings = OfflineStorage.getItem("degreeSettings")["data"];
  String selectedSemester = "";
  if (semester != null) {
    if (semester == tr("First Semester"))
      selectedSemester = "first";
    else if (semester == tr("Second Semester"))
      selectedSemester = "second";
    else
      selectedSemester = "all";
  }
  if (degreeSettings != null) {
    if (selectedSemester != "" && selectedSemester != "all") {
      if (degreeSettings['${selectedSemester}_semester'] != null &&
          degreeSettings['${selectedSemester}_semester']
                  ['${selectedSemester}_semester'] ==
              1) {
        options = getPeriods(degreeSettings, selectedSemester);
      }
    } else {
      if (degreeSettings['second_semester'] != null &&
          degreeSettings['second_semester']['second_semester'] == 1) {
        options = getPeriods(degreeSettings, "second");
      } else if (degreeSettings['first_semester'] != null &&
          degreeSettings['first_semester']['first_semester'] == 1) {
        options = getPeriods(degreeSettings, "first");
      }
    }
  }
  return options;
}

List<FormBuilderFieldOption> getPeriods(
    dynamic degreeSettings, String selectedSemester) {
  List<FormBuilderFieldOption> options = [];
  if (degreeSettings['${selectedSemester}_semester']
          ['${selectedSemester}_period_1'] ==
      1)
    options.add(FormBuilderFieldOption(
      value: tr("First Period"),
    ));
  if (degreeSettings['${selectedSemester}_semester']
          ['${selectedSemester}_period_2'] ==
      1)
    options.add(FormBuilderFieldOption(
      value: tr("Second Period"),
    ));
  if (degreeSettings['${selectedSemester}_semester']
          ['${selectedSemester}_period_3'] ==
      1)
    options.add(FormBuilderFieldOption(
      value: tr("Third Period"),
    ));
  if (degreeSettings['${selectedSemester}_semester']
          ['${selectedSemester}_period_4'] ==
      1)
    options.add(FormBuilderFieldOption(
      value: tr("Fourth Period"),
    ));
  if (degreeSettings['${selectedSemester}_semester']
          ['${selectedSemester}_all_periods'] ==
      1)
    options.add(FormBuilderFieldOption(
      value: tr("All Periods"),
    ));
  return options;
}

String getSemester(var selected) {
  String semester = "9";
  if (selected == tr("First Semester"))
    semester = "1";
  else if (selected == tr("Second Semester")) semester = "2";
  return semester;
}

String getLanguage(var selected, String semester, String period) {
  String language = "";
  if (selected == tr("English")) {
    if (period == "9") {
      language = semester == "9" ? "DGR02STDAPE_RET" : "DGR02STDAPE2_RET";
    } else {
      language = "DGR02STDPE_RET";
    }
  } else {
    if (period == "9") {
      language = semester == "9" ? "DGR02STDA_RET" : "DGR02STD_RET";
    } else {
      language = "DGR02STDP_RET";
    }
  }
  return language;
}

String getPeriod(var selected) {
  String period = "9";
  if (selected == tr("First Period"))
    period = "1";
  else if (selected == tr("Second Period"))
    period = "2";
  else if (selected == tr("Third Period"))
    period = "3";
  else if (selected == tr("Fourth Period")) period = "4";
  return period;
}
/*
    BaseView<StudentViewModel>(builder: (context, model, child) {
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
                          StudentTool(
                            icon: FontAwesomeIcons.graduationCap,
                            backgroundColor: Colors.redAccent.shade100,
                            title: tr("Degrees"),
                            onTab: () {
                              NavigationHelper.push(
                                  context: context,
                                  page: StudentPaymentView(
                                      studentNo: student.no));
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
            alignment: Alignment.centerRight,
            image: AssetImage('assets/students_images/$gender$photoNum.png')),
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
*/
