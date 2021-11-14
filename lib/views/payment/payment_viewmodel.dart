import 'package:injectable/injectable.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/model/payment/parent_payment.dart';
import 'package:school_erp/services/api/api.dart';

import 'package:school_erp/views/base_viewmodel.dart';

@lazySingleton
class PaymentViewModel extends BaseViewModel {
  ParentPayment? studentPayments;
  Future<bool> getStudentPayments(String studentNo) async {
    studentPayments = await locator<Api>().getParentPayments(studentNo);
    return true;
  }
}
