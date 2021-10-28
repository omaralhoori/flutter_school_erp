import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/lifecycle_manager.dart';
import 'package:school_erp/widgets/home_widgets/content_tab.dart';
import 'config/frappe_palette.dart';
import 'model/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'utils/enums.dart';

import 'services/connectivity_service.dart';

import 'views/home/home_view.dart';
import 'views/login/login_view.dart';

import 'package:easy_localization/easy_localization.dart';

import 'widgets/home_widgets/gallery_tab.dart';

class FrappeApp extends StatefulWidget {
  @override
  _FrappeAppState createState() => _FrappeAppState();
}

class _FrappeAppState extends State<FrappeApp> {
  bool _isLoggedIn = false;
  bool _isLoaded = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() {
    setState(() {
      _isLoggedIn = Config().isLoggedIn;
    });

    _isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: LifeCycleManager(
        child: StreamProvider<ConnectivityStatus>(
          initialData: ConnectivityStatus.offline,
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            title: 'Frappe',
            theme: new ThemeData(
              textTheme: GoogleFonts.interTextTheme(
                Theme.of(context).textTheme.apply(

                ),
              ),
              disabledColor: Colors.black,
              primaryColor: Colors.white,
              colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black54),
            ),
            home: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scaffold(
                body: _isLoaded
                    ? _isLoggedIn
                        ? HomeView()
                        : LoginView()
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
