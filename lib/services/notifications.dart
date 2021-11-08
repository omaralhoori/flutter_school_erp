import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Notifications(){
    _getPermissions();
  }

  Future<void> _getPermissions()async{
    await Firebase.initializeApp();
    try{
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
    }catch(e){
      throw Exception(e);
    }
  }

  void startForegroundListening(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.title} and ${message.notification!.body}');
      }
    });
  }




  void startBackgroundListening() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void handleBackgroundMessages() {
    FirebaseMessaging.onMessageOpenedApp.first.then((value) {
      print("Message data: ${value.notification!.title} : ${value.notification!.body}");
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.data}");
}