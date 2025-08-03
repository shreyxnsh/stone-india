import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/main.dart';
import 'package:stoneindia/screen/SBCustomer/sbcustomerdashboard.dart';
import 'package:stoneindia/screen/SBTeam/sbteamdashboard.dart';
import 'package:stoneindia/screen/signin.dart';
import 'package:stoneindia/screen/signup.dart';
import 'package:stoneindia/screen/walkthrough.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/utils/s_navigate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    checkFirstSeen();
  }

  Future checkFirstSeen() async {
    setStatusBarColor(Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark);
    await Future.delayed(const Duration(seconds: 2));
    if (getBoolAsync(IS_WALKTHROUGH_FIRST, defaultValue: false)) {
      // SignInScreen(isfirst: true).launch(context, isNewTask: true);
      // const SBCustomerDashboard(
      //         runHomeApi: true, isfilter: false, isfirst: true)
      //     .launch(context);

      if (flowStats['login-first'] == true) {
        StoneNavigate.to(
          const SignInScreen(
            isfirst: true,
          ),
        );
        return;
      }

      StoneNavigate.to(
        const SBCustomerDashboard(
          runHomeApi: true,
          isfilter: false,
          isfirst: true,
        ),
      );
    } else {
      // const WalkThroughScreen().launch(context, isNewTask: true);
      StoneNavigate.toAndRemoveUntil(
        const WalkThroughScreen(),
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: SizedBox(
          width: 200,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
