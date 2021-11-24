class StudentExtraAmount {
  late String code;
  late String name;
  late String voucher;
  late String date;
  late String? note;
  late String amt;

  StudentExtraAmount({
    required this.code,
    required this.name,
    required this.voucher,
    required this.date,
    required this.amt,
    this.note,
  });

  StudentExtraAmount.fromJson(Map<String, dynamic> json) {
    code = json['TRXEXCODE'];
    name = json['TRXEXNAME'];
    voucher = json['TRXEXVOUCHER'];
    date = json['TRXEXDATE'];
    amt = json['TRXEXAMT'];
    note = json['TRXEXNOTE'];
  }
}
