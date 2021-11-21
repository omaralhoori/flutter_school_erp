import 'package:hive/hive.dart';
import 'package:school_erp/model/parent/student.dart';

part '../../adapters/parent.g.dart';

@HiveType(typeId: 7)
class Parent extends HiveObject {
  @HiveField(0)
  late String contractNo;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String branchCode;
  @HiveField(3)
  late String branchName;
  @HiveField(4)
  late String yearName;
  @HiveField(5)
  late List<Student> students;
  @HiveField(6)
  late String mobileNo;

  Parent({
    required this.contractNo,
    required this.name,
    required this.branchCode,
    required this.branchName,
    required this.yearName,
    required this.students,
    required this.mobileNo,
  });

  Parent.fromJson(Map<String, dynamic> json) {
    contractNo = json['contract_no'] ?? '';
    name = json['name'] ?? '';
    branchCode = json['branch_code'];
    branchName = json['branch_name'];
    yearName = json['year_name'];
    mobileNo = json['mobile_no'] ?? '';
    Iterable i = json['students'];
    students = List.from(i.map((e) => Student.fromJson(e)));
  }
}
