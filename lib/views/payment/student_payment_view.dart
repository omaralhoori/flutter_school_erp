import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/payment/payment_viewmodel.dart';
import 'package:school_erp/widgets/payment_widgets.dart';

class StudentPaymentView extends StatefulWidget {
  final String studentNo;
  const StudentPaymentView({Key? key, required this.studentNo})
      : super(key: key);

  @override
  _StudentPaymentViewState createState() => _StudentPaymentViewState(studentNo);
}

class _StudentPaymentViewState extends State<StudentPaymentView> {
  final String studentNo;

  _StudentPaymentViewState(this.studentNo);

  @override
  Widget build(BuildContext context) {
    return BaseView<PaymentViewModel>(
      builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(),
          body: FutureBuilder(
            future: model.getStudentPayments(studentNo),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return model.studentPayments != null
                    ? ParentPaymentView(parentPayment: model.studentPayments!)
                    : Center(child: Text(tr("No data.")));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}
