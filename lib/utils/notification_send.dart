import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/utils/local_notifacation_service.dart';

class NotificationSend {
  static bool notificationReceived = false;

  static Future<void> registerNotification() async {
    bool notificationPermission =
        await AwesomeNotifications().isNotificationAllowed();
    if (!notificationPermission) {
      return;
    }

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (Platform.isIOS) {
        String? apnsToken = await messaging.getAPNSToken();
        if (apnsToken == null) {
          print("APNS token is not available yet. Waiting...");
          await Future.delayed(Duration(seconds: 3)); // Wait for APNS token
          apnsToken = await messaging.getAPNSToken();
        }

        if (apnsToken == null) {
          print("APNS token is still not available. Exiting...");
          return;
        }
      }

      String? token = await messaging.getToken();
      print('FCM Token: $token');
      setStringAsync(FCM_TOKEN, token ?? "");

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.notification != null) {
          print("Notification Opened: ${message.notification!.title}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("New Message: ${message.notification?.title}");
        LocalNotificationService.createanddisplaynotification(message);
      });
    } else {
      print("Notification permission declined by user.");
    }
  }
}
