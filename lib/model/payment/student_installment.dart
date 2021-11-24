class StudentInstallment {
  late String no;
  late String date;
  late String amt;
  late String paid;
  late String balance;

  StudentInstallment({
    required this.no,
    required this.paid,
    required this.balance,
    required this.date,
    required this.amt,
  });

  StudentInstallment.fromJson(Map<String, dynamic> json) {
    no = json['PAYNO'];
    paid = json['PAYPAID'];
    balance = json['PAYBAL'];
    date = json['PAYDATE'];
    amt = json['PAYAMT'];
  }
}
