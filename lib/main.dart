import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/screen/splash.dart';
import 'package:stoneindia/utils/local_notifacation_service.dart';
import 'contants.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print(message.notification!.title);
    print(message.notification!.body);
    print("Data on App Background ${message.data}");
    print("Notification on App Background ${message.notification!.title}");
    LocalNotificationService.createanddisplaynotification(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  await initialize();
  await initPlatformState();
  runApp(const MyApp());
}

initPlatformState() async {
  String appBadgeSupported;
  try {
    bool res = await FlutterAppBadger.isAppBadgeSupported();
    if (res) {
      appBadgeSupported = 'Supported';
      FlutterAppBadger.removeBadge();
    } else {
      appBadgeSupported = 'Not supported';
    }
  } on PlatformException {
    appBadgeSupported = 'Failed to get badge support.';
  }
  print(appBadgeSupported);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'google_sans',
        primaryColor: appPrimaryColor,
        scaffoldBackgroundColor: scaffoldBgColor,
        // accentColor: appSecondaryColor,
        cardColor: Colors.white,
        dividerColor: viewLineColor,
        textTheme: const TextTheme(headlineLarge: TextStyle()),
        dialogBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: primaryColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: scaffoldBgColor),
        ),
        iconTheme: const IconThemeData(color: Colors.black54),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
      ),
      themeMode: ThemeMode.light,
      title: appName,
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
      builder: scrollBehaviour(),
    );
  }
}
