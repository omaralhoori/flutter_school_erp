import 'package:flutter/material.dart';
import 'package:school_erp/services/notifications.dart';
import 'package:school_erp/services/storage_service.dart';

import 'app/locator.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  LifeCycleManager({required this.child, required this.navigatorKey});

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
        break;
      case AppLifecycleState.inactive:
        print('detached: $state');
        await locator<StorageService>().putSharedPrefBoolValue(
          "backgroundTask",
          true,
        );
        notifications.startBackgroundListening();
        notifications.handleBackgroundMessages(widget.navigatorKey);
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        await locator<StorageService>().putSharedPrefBoolValue(
          "backgroundTask",
          false,
        );
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
