import 'package:flutter/material.dart';
import 'package:school_erp/app.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/utils/helpers.dart';

void main() async {
  setupLocator();
  await initDb();

  runApp(FrappeApp());
}
