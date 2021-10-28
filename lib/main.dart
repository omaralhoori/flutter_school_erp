import 'package:flutter/material.dart';
import 'package:school_erp/app.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/utils/dio_helper.dart';
import 'package:school_erp/utils/helpers.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  setupLocator();
  await initDb();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await DioHelper.init();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/langs',
        fallbackLocale: Locale('en'),
        child: FrappeApp()),
  );
}