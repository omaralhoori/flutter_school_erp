import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/lifecycle_manager.dart';
import 'package:school_erp/splash_view.dart';
import 'package:school_erp/storage/offline_storage.dart';
import 'package:school_erp/views/messaging/direct_messages_view.dart';
import 'package:school_erp/views/messaging/group_messages_view.dart';
import 'config/palette.dart';
import 'storage/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';

import 'utils/enums.dart';

import 'services/connectivity_service.dart';

import 'views/home/home_view.dart';

import 'package:easy_localization/easy_localization.dart';

class FrappeApp extends StatefulWidget {
  @override
  _FrappeAppState createState() => _FrappeAppState();
}

class _FrappeAppState extends State<FrappeApp> {
  bool _isLoggedIn = false;
  bool _isGuest = false;
  bool _isLoaded = false;
  RemoteMessage? payloadMessage;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    _checkIfLoggedIn();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      setState(() {
        payloadMessage = message;
      });
      //NavigationHelper.push(context: context, page: ContactView());
    });
    super.initState();
  }

  void _checkIfLoggedIn() {
    setState(() {
      _isLoggedIn = Config().isLoggedIn;
      _isGuest = Config().isGuest;
    });

    _isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    RemoteMessage? _payloadMessage = payloadMessage;
    payloadMessage = null;
    return Portal(
      child: LifeCycleManager(
        navigatorKey: navigatorKey,
        child: StreamProvider<ConnectivityStatus>(
          initialData: ConnectivityStatus.offline,
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            title: 'Retaal International Academy',
            theme: Palette.customTheme,
            home: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scaffold(
                body: _isLoaded
                    ? _isLoggedIn
                        ? directedPage(_payloadMessage)
                        : _isGuest
                            ? directedPage(_payloadMessage)
                            : SplashView()
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

Widget directedPage(RemoteMessage? message) {
  if (message != null && !Config().isGuest) {
    if (message.data["type"] != null) {
      if (message.data["type"] == "School Direct Message") {
        return DirectMessagesView();
      }
      if (message.data["type"] == "School Group Message") {
        if (message.data["student_no"] != null) {
          return GroupMessagesView(
            studentNo: message.data["student_no"],
          );
        }
      }
    }
  }
  return HomeView();
}
