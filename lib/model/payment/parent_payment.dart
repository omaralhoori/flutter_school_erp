import 'package:school_erp/model/payment/student_extra_amount.dart';
import 'package:school_erp/model/payment/student_fees.dart';
import 'package:school_erp/model/payment/student_installment.dart';
import 'package:school_erp/model/payment/student_payment.dart';
import 'package:school_erp/model/payment/student_transaction.dart';

class ParentPayment {
  late String year;
  late String name;
  late String branchCode;
  late String contractNo;
  late String branchName;
  late List<StudentPayment> students;

  ParentPayment({
    required this.name,
    required this.year,
    required this.branchCode,
    required this.contractNo,
    required this.branchName,
    required this.students,
  });

  ParentPayment.fromJson(Map<String, dynamic> json) {
    year = json['YEARNAME'];
    name = json['CONNAME'];
    branchCode = json['BRNCODE'];
    branchName = json['BRNNAME'];
    contractNo = json['CONNO'];

    Iterable i = json['student_list'];
    students = List.of(i.map((t) => StudentPayment.fromJson(t)));
  }
}
