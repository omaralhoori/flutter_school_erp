import 'package:hive/hive.dart';

part '../../adapters/student.g.dart';

@HiveType(typeId: 6)
class Student extends HiveObject {
  @HiveField(0)
  late String no;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String classCode;
  @HiveField(3)
  late String className;
  @HiveField(4)
  late String sectionCode;
  @HiveField(5)
  late String sectionName;
  @HiveField(6)
  late String gender;

  Student({
    required this.no,
    required this.name,
    required this.classCode,
    required this.className,
    required this.sectionCode,
    required this.sectionName,
    required this.gender,
  });

  Student.fromJson(Map<String, dynamic> json) {
    no = json['student_no'];
    name = json['student_name'];
    classCode = json['class_code'];
    className = json['class_name'];
    sectionCode = json['section_code'];
    sectionName = json['section_name'];
    gender = json['student_gender'];
  }
}
