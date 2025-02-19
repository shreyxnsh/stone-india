import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/utils/local_notifacation_service.dart';

class NotificationSend {
  static bool notificationReceived = false;
  static void registerNotification() async {
    late final FirebaseMessaging messaging;
    // await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // check of debug mode
      bool isDebugMode = kDebugMode;
      if (Platform.isIOS == true && isDebugMode) {
        log("skip for ios");
        return;
      }

      String? token = await FirebaseMessaging.instance.getToken();
      print('token: $token');
      setStringAsync(FCM_TOKEN, token.toString());

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("Data on App open ${message.data}");
          print("Notification on App open ${message.notification}");
          notificationReceived = true;
          LocalNotificationService.createanddisplaynotification(message);
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(message.notification!.title);
        print(message.notification!.body);
        print("Data on Message ${message.data}");
        print("Notification on Message ${message.notification?.title}");
        notificationReceived = true;
        LocalNotificationService.createanddisplaynotification(message);
      });
    } else {
      print("permission declined by user");
    }
  }
}
