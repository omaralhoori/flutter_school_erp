import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/payment/parent_payment.dart';
import 'package:school_erp/model/payment/student_extra_amount.dart';
import 'package:school_erp/model/payment/student_fees.dart';
import 'package:school_erp/model/payment/student_installment.dart';
import 'package:school_erp/model/payment/student_payment.dart';
import 'package:school_erp/model/payment/student_transaction.dart';

class ParentPaymentWidget extends StatelessWidget {
  final ParentPayment parentPayment;
  const ParentPaymentWidget({Key? key, required this.parentPayment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(parentPayment.name),
          Text(parentPayment.year),
          Text(parentPayment.branchCode),
        ],
      ),
    );
  }
}

class StudentPaymentWidget extends StatelessWidget {
  final ParentPayment parentPayment;
  final Function onPressed;
  const StudentPaymentWidget(
      {Key? key, required this.parentPayment, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (parentPayment.students.length > 0)
            Container(
              margin: EdgeInsets.only(bottom: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        tr("Download as pdf"),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  DownloadButton(onPressed: onPressed),
                ],
              ),
            ),
          if (parentPayment.students.length > 0)
            PaymentTables(studentPayment: parentPayment.students[0])
        ],
      ),
    );
  }
}

class PaymentTables extends StatelessWidget {
  const PaymentTables({Key? key, required this.studentPayment})
      : super(key: key);
  final StudentPayment studentPayment;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaymentTable(
          title: tr("Transactions"),
          table: TransactionsTable(transactions: studentPayment.transactions),
        ),
        SizedBox(
          height: 24,
        ),
        PaymentTable(
          title: tr("Extra Amounts"),
          table: ExtraAmountsTable(transactions: studentPayment.extraAmounts),
        ),
        SizedBox(
          height: 24,
        ),
        PaymentTable(
          title: tr("Installments"),
          table: InstallmentsTable(transactions: studentPayment.installments),
        ),
        SizedBox(
          height: 24,
        ),
        PaymentTable(
          title: tr("Fees"),
          table: FeesTable(transactions: studentPayment.fees),
        ),
      ],
    );
  }
}

class TransactionsTable extends StatelessWidget {
  const TransactionsTable({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  final List<StudentTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: [
          DataColumn(label: Text(tr("Code"))),
          DataColumn(label: Text(tr("Name"))),
          DataColumn(label: Text(tr("Voucher"))),
          DataColumn(label: Text(tr("Date"))),
          DataColumn(label: Text(tr("Note"))),
          DataColumn(label: Text(tr("Amount"))),
        ],
        rows: List.of(transactions.map((e) => DataRow(cells: [
              DataCell(Text(e.code)),
              DataCell(Text(e.name)),
              DataCell(Text(e.voucher)),
              DataCell(Text(e.date)),
              DataCell(Text(e.note ?? '')),
              DataCell(Text(e.amt)),
            ]))));
  }
}

class ExtraAmountsTable extends StatelessWidget {
  const ExtraAmountsTable({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  final List<StudentExtraAmount> transactions;

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: [
          DataColumn(label: Text(tr("Code"))),
          DataColumn(label: Text(tr("Name"))),
          DataColumn(label: Text(tr("Voucher"))),
          DataColumn(label: Text(tr("Date"))),
          DataColumn(label: Text(tr("Note"))),
          DataColumn(label: Text(tr("Amount"))),
        ],
        rows: List.of(transactions.map((e) => DataRow(cells: [
              DataCell(Text(e.code)),
              DataCell(Text(e.name)),
              DataCell(Text(e.voucher)),
              DataCell(Text(e.date)),
              DataCell(Text(e.note ?? '')),
              DataCell(Text(e.amt)),
            ]))));
  }
}

class InstallmentsTable extends StatelessWidget {
  const InstallmentsTable({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  final List<StudentInstallment> transactions;

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: [
          DataColumn(label: Text(tr("NO"))),
          DataColumn(label: Text(tr("Date"))),
          DataColumn(label: Text(tr("Amount"))),
          DataColumn(label: Text(tr("Paid"))),
          DataColumn(label: Text(tr("Balance"))),
        ],
        rows: List.of(transactions.map((e) => DataRow(cells: [
              DataCell(Text(e.no)),
              DataCell(Text(e.date)),
              DataCell(Text(e.amt)),
              DataCell(Text(e.paid)),
              DataCell(Text(e.balance)),
            ]))));
  }
}

class FeesTable extends StatelessWidget {
  const FeesTable({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  final List<StudentFees> transactions;

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: [
          DataColumn(label: Text(tr("Code"))),
          DataColumn(label: Text(tr("Name"))),
          DataColumn(label: Text(tr("Fee"))),
          DataColumn(label: Text(tr("Discount"))),
          DataColumn(label: Text(tr("Total"))),
          DataColumn(label: Text(tr("Paid"))),
          DataColumn(label: Text(tr("Balance"))),
        ],
        rows: List.of(transactions.map((e) => DataRow(cells: [
              DataCell(Text(e.code)),
              DataCell(Text(e.name)),
              DataCell(Text(e.fee)),
              DataCell(Text(e.dsc)),
              DataCell(Text(e.tot)),
              DataCell(Text(e.paid)),
              DataCell(Text(e.bal)),
            ]))));
  }
}

class PaymentTable extends StatelessWidget {
  const PaymentTable({
    Key? key,
    required this.title,
    required this.table,
  }) : super(key: key);

  final String title;
  final Widget table;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: table)
      ],
    );
  }
}

class DownloadButton extends StatelessWidget {
  final Function onPressed;
  const DownloadButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Palette.primaryButtonColor,
      child: Icon(Icons.download),
      onPressed: () {
        onPressed();
      },
    );
  }
}
