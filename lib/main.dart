import 'package:flutter/material.dart';
import 'package:school_erp/app.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/services/notifications.dart';
import 'package:school_erp/services/storage_service.dart';
import 'package:school_erp/utils/dio_helper.dart';
import 'package:school_erp/utils/helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school_erp/views/login/login_viewmodel.dart';

void main() async {
  setupLocator();
  await initDb();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Notifications.initFCM();
  Notifications.subscribeToTopics();
  final List<Locale> systemLocales = WidgetsBinding.instance!.window.locales;

  await EasyLocalization.ensureInitialized();
  await DioHelper.init();
  await locator<LoginViewModel>().loginMain();
  await locator<StorageService>().checkPostVersions();
  await locator<StorageService>().getSchoolData();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/langs',
        fallbackLocale: Locale('en'),

        // startLocale: Locale(systemLocales.first.languageCode),
        child: FrappeApp()),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image(
                    image: AssetImage('assets/app_logo.png'),
                    width: 240,
                    height: 180,
                  ),
                ),
                CircularProgressIndicator()
              ],
            ),
          ),
        ));
  }
}
