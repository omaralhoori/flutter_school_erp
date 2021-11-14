import 'package:school_erp/model/payment/student_extra_amount.dart';
import 'package:school_erp/model/payment/student_fees.dart';
import 'package:school_erp/model/payment/student_installment.dart';
import 'package:school_erp/model/payment/student_transaction.dart';

class StudentPayment {
  late String no;
  late String name;
  late String gender;
  late String classCode;
  late String className;
  late String sectionCode;
  late String sectionName;
  late List<StudentTransaction> transactions;
  late List<StudentExtraAmount> extraAmounts;
  late List<StudentInstallment> installments;
  late List<StudentFees> fees;

  StudentPayment({
    required this.no,
    required this.name,
    required this.gender,
    required this.classCode,
    required this.className,
    required this.sectionCode,
    required this.sectionName,
    required this.transactions,
    required this.extraAmounts,
    required this.installments,
    required this.fees,
  });

  StudentPayment.fromJson(Map<String, dynamic> json) {
    no = json['STDNO'];
    name = json['STDNAME'];
    gender = json['STDGENDER'];
    classCode = json['CLSCODE'];
    className = json['CLSNAME'];
    sectionCode = json['SECCODE'];
    sectionName = json['SECNAME'];

    Iterable i = json['StudentTransaction'];
    transactions = List.of(i.map((t) => StudentTransaction.fromJson(t)));

    i = json['StudentExtraAmount'];
    extraAmounts = List.of(i.map((t) => StudentExtraAmount.fromJson(t)));

    i = json['StudentInstallment'];
    installments = List.of(i.map((t) => StudentInstallment.fromJson(t)));

    i = json['StudentFees'];
    fees = List.of(i.map((t) => StudentFees.fromJson(t)));
  }
}
