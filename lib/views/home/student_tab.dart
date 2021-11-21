import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:school_erp/model/parent/student.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/payment/parent_payment.dart';
import 'package:school_erp/model/payment/student_extra_amount.dart';
import 'package:school_erp/model/payment/student_transaction.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';
import 'package:school_erp/views/student/student_view.dart';

class StudentTab extends StatefulWidget {
  const StudentTab({Key? key}) : super(key: key);

  @override
  _StudentTabState createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (context, home, _) {
        return FutureBuilder(
            future: home.getParentData(),
            builder: (context, snapshot) {
              return RefreshIndicator(
                onRefresh: () async {
                  await home.getParentData();
                  setState(() {});
                },
                child: SingleChildScrollView(
                  child: snapshot.hasData
                      ? home.parentData != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(tr("Branch") +
                                        ": " +
                                        home.parentData!.branchCode +
                                        " - " +
                                        home.parentData!.branchName),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(tr("Year") +
                                        ": " +
                                        home.parentData!.yearName),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(tr("Contract No") +
                                        ": " +
                                        home.parentData!.contractNo),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            home.parentData!.students.length,
                                        itemBuilder: (context, index) {
                                          return StudentCard(
                                              student: home
                                                  .parentData!.students[index]);
                                        })
                                  ],
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                tr("No data."),
                                textAlign: TextAlign.center,
                              ),
                            )
                      : Center(child: CircularProgressIndicator()),
                ),
              );
            });
      },
    );
  }
}

class StudentCard extends StatelessWidget {
  const StudentCard({Key? key, required this.student}) : super(key: key);
  final Student student;
  final Color textColor = Palette.studentCardForegroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          NavigationHelper.push(
              context: context, page: StudentView(student: student));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 40.0),
                    height: 80,
                    decoration: BoxDecoration(
                        color: Palette.studentCardBackgroundColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 10))
                        ]),
                    child: Center(
                      child: Text(
                        student.name,
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.centerLeft,
                    child: Container(
                      margin: new EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        height: 55,
                        width: 55,
                      ),
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.centerLeft,
                    child: Container(
                      margin: new EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          color: Palette.studentCardBackgroundColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(2, 0))
                          ]),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                            child: Text(
                          student.no,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
