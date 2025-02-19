import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/screen/SBCustomer/sbcustomerdashboard.dart';
import 'package:stoneindia/screen/SBTeam/sbteamdashboard.dart';
import 'package:stoneindia/screen/signin.dart';
import 'package:stoneindia/screen/signup.dart';
import 'package:stoneindia/screen/walkthrough.dart';

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
    if (getBoolAsync(IS_LOGGED_IN, defaultValue: false)) {
      if (getStringAsync(USER_ROLE) == UserRoleStoneBharatTeam) {
        const SBTeamDashboard(runHomeApi: true, isfilter: false)
            .launch(context, isNewTask: true);
      } else if (getStringAsync(USER_ROLE) == UserRoleCustomer) {
        const SBCustomerDashboard(
                runHomeApi: true, isfilter: false, isfirst: false)
            .launch(context, isNewTask: true);
      } else {
        const SignUpScreen().launch(context, isNewTask: true);
      }
    } else {
      if (getBoolAsync(IS_WALKTHROUGH_FIRST, defaultValue: false)) {
        // SignInScreen(isfirst: true).launch(context, isNewTask: true);
        const SignUpScreen().launch(context);
      } else {
        const WalkThroughScreen().launch(context, isNewTask: true);
      }
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
