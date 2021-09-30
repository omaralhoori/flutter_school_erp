import 'package:school_erp/model/common.dart';

class Constants {
  static var offlinePageSize = 50;
  static var pageSize = 10;

  static var imageExtensions = ['jpg', 'jpeg'];

  static List<FilterOperator> filterOperators = [
    FilterOperator(label: "Like", value: "like"),
    FilterOperator(label: "Equals", value: "="),
    FilterOperator(label: "Not Equals", value: "!="),
    FilterOperator(label: "Not Like", value: "not like"),
    // FilterOperator(label: "In", value: "in"),
    // TODO
    // FilterOperator(label: "Not In", value: "not in"),
    FilterOperator(label: "Is", value: "is"),
  ];
}
