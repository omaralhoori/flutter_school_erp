class StudentTransaction {
  late String code;
  late String name;
  late String voucher;
  late String date;
  late String? note;
  late String amt;

  StudentTransaction({
    required this.code,
    required this.name,
    required this.voucher,
    required this.date,
    required this.amt,
    this.note,
  });

  StudentTransaction.fromJson(Map<String, dynamic> json) {
    code = json['TRXCODE'];
    name = json['TRXNAME'];
    voucher = json['TRXVOUCHER'];
    date = json['TRXDATE'];
    amt = json['TRXAMT'];
    note = json['TRXNOTE'];
  }
}
