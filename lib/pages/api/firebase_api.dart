import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uteeth_socorrista/pages/home_page.dart';

Future<void> handleMessage(RemoteMessage? message) {
  return Navigator.push(
    HomePage() as BuildContext,
    MaterialPageRoute(
      builder: (_) => HomePage(),
    ),
  );
}

class FirebaseApi {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage((message) => handleMessage(message));
  }
}
