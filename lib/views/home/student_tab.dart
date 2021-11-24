import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/model/parent/parent.dart';
import 'package:school_erp/model/parent/student.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/storage/offline_storage.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';
import 'package:school_erp/views/student/student_view.dart';

class StudentTab extends StatelessWidget {
  const StudentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (context, home, _) {
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/students_images/stuednts_tab_background.png'),
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter)),
          child: FutureBuilder(
              future: home.getParentData(),
              builder: (context, snapshot) {
                return StudentRefresh(
                  snapshot: snapshot,
                  parentData: home.parentData,
                  onRefresh: home.getParentData,
                );
              }),
        );
      },
    );
  }
}

class StudentRefresh extends StatefulWidget {
  const StudentRefresh(
      {Key? key,
      required this.snapshot,
      required this.onRefresh,
      this.parentData})
      : super(key: key);
  final AsyncSnapshot<Object?> snapshot;
  final Parent? parentData;
  final Future<bool> Function() onRefresh;

  @override
  _StudentRefreshState createState() => _StudentRefreshState();
}

class _StudentRefreshState extends State<StudentRefresh> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        //await home.getParentData();
        await widget.onRefresh();
        setState(() {});
      },
      child: SingleChildScrollView(
        child: widget.snapshot.hasData
            ? widget.parentData != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Column(
                        children: [
                          ParentCard(parent: widget.parentData!),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.parentData!.students.length,
                              itemBuilder: (context, index) {
                                return StudentCard(
                                    student:
                                        widget.parentData!.students[index]);
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
  }
}

class ParentCard extends StatelessWidget {
  final Parent parent;
  ParentCard({Key? key, required this.parent}) : super(key: key);
  final String? userImage = OfflineStorage.getItem("userImage")["data"];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.white,
              //image: DecorationImage(image: AssetImage('assets/user-avatar.png'))
            ),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: userImage == null
                ? Image(
                    fit: BoxFit.fill,
                    width: 100,
                    height: 100,
                    image: AssetImage('assets/user-avatar.png'),
                  )
                : ClipOval(
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        imageUrl: Config.baseUrl + userImage!),
                  ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StudentInfo(
                    label: tr("Branch") + ": ",
                    value: parent.branchCode + " - " + parent.branchName),
                StudentInfo(label: tr("Year") + ": ", value: parent.yearName),
                StudentInfo(
                    label: tr("Contract No") + ": ", value: parent.contractNo),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  StudentCard({Key? key, required this.student}) : super(key: key);
  final Student student;
  final Color textColor = Palette.studentCardForegroundColor;
  final List<Color> bgColors = [
    Colors.amber.shade200,
    Colors.purple.shade100,
    Colors.blue.shade100,
    Colors.red.shade100,
    Colors.green.shade100
  ];
  final int colorIndex = Random().nextInt(5);
  @override
  Widget build(BuildContext context) {
    String gender = student.gender == 'Female' ? 'g' : 'b';
    int photoNum = int.parse(student.no) % 4 + 1;
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
                        color: bgColors[
                            colorIndex], //Palette.studentCardBackgroundColor,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            alignment: Alignment.centerRight,
                            image: AssetImage(
                                'assets/students_images/$gender$photoNum.png')),
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
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
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
                          color: bgColors[colorIndex],
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
