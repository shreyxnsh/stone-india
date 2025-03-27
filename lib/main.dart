import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/firebase_options.dart';
import 'package:stoneindia/screen/splash.dart';
import 'package:stoneindia/utils/local_notifacation_service.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'contants.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print(message.notification!.title);
    print(message.notification!.body);
    print("Data on App Background ${message.data}");
    print("Notification on App Background ${message.notification!.title}");
    LocalNotificationService.createanddisplaynotification(message);
  }
}

Future<void> appTracking() async {
  final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;

  while (status == TrackingStatus.notDetermined) {
    await Future.delayed(const Duration(seconds: 1));
    final TrackingStatus newStatus =
        await AppTrackingTransparency.requestTrackingAuthorization();
    if (newStatus != TrackingStatus.notDetermined) {
      break;
    }
  }
}

Future<void> tempLogin() async {
  if (getBoolAsync(IS_LOGGED_IN) == true) {
    return;
  }
  Map req = {
    'whatsapp_number': "911111111110",
    'fcm_token': "",
    'country_code': "91",
    'country_iso_code': "IN",
  };

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  await login(req).then((value) async {
    if (value["status"] == true &&
        value["messages"] == "Login successfully!" &&
        value['role'] == "customer") {
      setValue(USER_ID, value["data"]["id"]);
      setValue(FIRST_NAME, value["data"]["firstname"]);
      setValue(LAST_NAME, value["data"]["lastname"]);
      setValue(USER_MOBILE, value["data"]["whatsapp_number"]);
      setValue(USER_ROLE, value["data"]["role"]);
      setValue(USER_DISPLAY_NAME,
          value["data"]["firstname"] + " " + value["data"]["lastname"]);
      if (value["data"]["profile_img"] != null) {
        setValue(PROFILE_IMAGE, value["data"]["profile_img"]);
      }
    } else if (value["status"] == true &&
        value["messages"] == "Login successfully!" &&
        value['role'] == "team") {
      setValue(USER_ID, value["data"]["id"]);
      setValue(FIRST_NAME, value["data"]["firstname"]);
      setValue(LAST_NAME, value["data"]["lastname"]);
      setValue(USER_MOBILE, value["data"]["whatsapp_number"]);
      setValue(USER_ROLE, value["data"]["role"]);
      setValue(USER_DISPLAY_NAME,
          value["data"]["firstname"] + " " + value["data"]["lastname"]);
      if (value["data"]["profile_img"] != null) {
        setValue(PROFILE_IMAGE, value["data"]["profile_img"]);
      }

      // toast('Login Successfully');
    } else if (value["status"] == false) {
      toast(value["messages"].toString());
    } else {}
  }).catchError((e) {
    log(e.toString());
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  log(FirebaseAuth.instance.currentUser.toString());
  // lock to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();

  await initialize();
  await initPlatformState();
  tempLogin();
  appTracking();
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
