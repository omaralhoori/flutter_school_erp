import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/services/notifications.dart';
import 'package:school_erp/services/storage_service.dart';

import 'app/locator.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({required this.child});

  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  late Notifications notifications;
  @override
  void initState() {
    notifications = Notifications();
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        print('detached');
        await locator<StorageService>().putSharedPrefBoolValue(
          "backgroundTask",
          true,
        );
        notifications.startBackgroundListening();
        break;
      case AppLifecycleState.resumed:
        await locator<StorageService>().putSharedPrefBoolValue(
          "backgroundTask",
          false,
        );
        notifications.handleBackgroundMessages();
        notifications.startForegroundListening();
        print('resume...');
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }


}
