import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/views/content_preview_noti/content_preview_noti_view.dart';

class Notifications {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Notifications() {
    _getPermissions();
  }

  Future<void> _getPermissions() async {
    await Firebase.initializeApp();
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
    } catch (e) {
      throw Exception(e);
    }
  }
/*
  static Future<void> initFCM() async {
    //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }*/

  static void subscribeToTopics() {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.subscribeToTopic("news");
    _firebaseMessaging.subscribeToTopic("announcement");
    _firebaseMessaging.subscribeToTopic("moon");
  }

  static Future<String> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token ?? '';
  }

  void startForegroundListening() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title} and ${message.notification!.body}');
      }
    });
  }

  void startBackgroundListening() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void handleBackgroundMessages(GlobalKey<NavigatorState> navigatorKey) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ContentPreviewNotificationView(name: message.data['name'], type: message.data['type'],)));
      print(
          "Message data: ${message.notification!.title} : ${message.notification!.body}, ${message.data}");
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.data}");
}
