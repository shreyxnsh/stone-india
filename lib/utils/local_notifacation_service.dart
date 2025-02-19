import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LocalNotificationService{

  static void initialize() {

    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'key1',
              channelName: 'Stone Bharat',
              channelDescription: 'Stone Bharat',
              defaultColor: Colors.deepOrangeAccent,
              ledColor: Colors.white,
              playSound: true,
              enableLights: true,
              enableVibration: true,
              vibrationPattern: highVibrationPattern,
              importance: NotificationImportance.High
          )
        ]
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });


  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      String timeZon = await AwesomeNotifications().getLocalTimeZoneIdentifier();
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: message.data['android_channel_id'],
          title: message.notification!.title,
          body: message.notification!.body,
          // bigPicture: 'resource://drawable/human',
          // icon:'resource://drawable/car',
          // largeIcon:'resource://drawable/car',
          backgroundColor: Colors.grey,
          displayOnBackground: true,
          displayOnForeground: true,
        ),
        schedule: NotificationInterval(interval: 1, timeZone: timeZon, repeats: false, preciseAlarm: true),
      );

    } on Exception catch (e) {
      print(e);
    }
  }

}