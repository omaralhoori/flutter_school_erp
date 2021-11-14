class StudentFees {
  late String code;
  late String name;
  late String fee;
  late String dsc;
  late String tot;
  late String paid;
  late String bal;

  StudentFees({
    required this.code,
    required this.name,
    required this.fee,
    required this.dsc,
    required this.tot,
    required this.paid,
    required this.bal,
  });

  StudentFees.fromJson(Map<String, dynamic> json) {
    code = json['FEECODE'];
    name = json['FEENAME'];
    fee = json['AMTFEE'];
    dsc = json['AMFDSC'];
    tot = json['AMTTOT'];
    paid = json['AMTPAID'];
    bal = json['AMTBAL'];
  }
}
