import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/screen/about_us.dart';
import 'package:stoneindia/screen/editprofile.dart';
import 'package:stoneindia/screen/signin.dart';
import 'package:stoneindia/screen/terms_and_condition.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:stoneindia/widget/appsetting.dart';
import'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

class SBCustomerSettingScreen extends StatefulWidget {
  const SBCustomerSettingScreen({super.key});

  @override
  _SBCustomerSettingScreenState createState() => _SBCustomerSettingScreenState();
}

class _SBCustomerSettingScreenState extends State<SBCustomerSettingScreen> {
  @override

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: HeadingAppBar(context, name: 'Settings'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          32.height,
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomRight,
                            children: [
                              getStringAsync(PROFILE_IMAGE).validate().isNotEmpty
                                  ? cachedImage(
                                getStringAsync(PROFILE_IMAGE),
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ).cornerRadiusWithClipRRect(180)
                                  : Container(
                                height: 90,
                                width: 90,
                                padding: const EdgeInsets.all(16),
                                decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: profileBgColor,
                                  boxShape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person_outline_rounded),
                              ),
                              Positioned(
                                bottom: -8,
                                left: 0,
                                right: -60,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: appPrimaryColor,
                                    boxShape: BoxShape.circle,
                                    border: Border.all(color: white, width: 3),
                                  ),
                                  child: Image.asset("assets/icons/edit.png", height: 20, width: 20, color: Colors.white),
                                ).onTap( () {
                                        const EditProfileScreen().launch(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          24.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${getStringAsync(FIRST_NAME)} ',
                                style: boldTextStyle(size: 20),
                              ),
                              Text(
                                getStringAsync(LAST_NAME),
                                style: boldTextStyle(size: 20),
                              ),
                            ],
                          ),
                          10.height,
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       "ID - ${getIntAsync(USER_ID).toString()}",
                          //     ),
                          //   ],
                          // ),
                          // 28.height,
                        ],
                      ),
                    ),
                    42.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Container(
                            height: 600,
                            margin: const EdgeInsets.only(top: 32),
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                const AppSettingItemWidget(
                                    name: 'T & C',
                                    image: "assets/icons/tandc.png",
                                    subTitle: 'Terms & Condition',
                                    widget: TandCScreen()
                                ),
                                const AppSettingItemWidget(
                                  name: 'About Us',
                                  image: "assets/icons/aboutus.png",
                                  widget: AboutUsScreen(),
                                  subTitle: 'About Stone India',
                                ),
                                AppSettingItemWidget(
                                  name: 'Rate Us',
                                  icon: Image.asset(
                                    "assets/icons/rate.png",
                                    height: 40,
                                    width: 40,
                                    color: kPrimaryColor,
                                  ),
                                  subTitle: 'Your Review Counts',
                                  onTap: () {
                                    if(Platform.isAndroid){
                                      launch("${playStoreBaseURL}com.stoneindia.stoneindia");
                                    }
                                    if(Platform.isIOS){
                                      launch("${appStoreBaseURL}com.stoneindia.stoneindia");
                                    }else{
                                      launch("${playStoreBaseURL}com.stoneindia.stoneindia");
                                    }
                                  },
                                ),
                                AppSettingItemWidget(
                                    name: 'Share Stone India',
                                    icon: Image.asset(
                                      "assets/icons/share.png",
                                      height: 30,
                                      width: 30,
                                      color: kPrimaryColor,
                                    ),
                                    subTitle: 'Share Application',
                                    onTap: () {
                                      if(Platform.isAndroid){
                                        Share.share('Check out the Stone India Application!\n\n${"${playStoreBaseURL}com.stoneindia.stoneindia"}');
                                      }
                                      if(Platform.isIOS){
                                        Share.share('Check out the Stone India Application!\n\n${"${appStoreBaseURL}com.stoneindia.stoneindia"}');
                                      }else{
                                        Share.share('Check out the Stone India Application!\n\n${"${playStoreBaseURL}com.stoneindia.stoneindia"}');
                                      }
                                    }),
                                AppSettingItemWidget(
                                  name: 'Logout',
                                  subTitle: 'Thanks For Visiting',
                                  image: "assets/icons/switch.png",
                                  onTap: () async {
                                    showConfirmDialogCustom(
                                      context,
                                      primaryColor: primaryColor,
                                      negativeText: 'Cancel',
                                      positiveText: 'Yes',
                                      onAccept: (c) async {
                                        setValue(IS_LOGGED_IN, false);
                                        push(const SignInScreen(isfirst: false), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                                      },
                                      title: 'Are You Sure To Logout' '?',
                                    );
                                  },
                                ),
                                AppSettingItemWidget(
                                  name: 'Close Account',
                                  subTitle: 'Close my account',
                                  image: "assets/icons/close.png",
                                  onTap: () async {
                                    showConfirmDialogCustom(
                                      context,
                                      primaryColor: primaryColor,
                                      negativeText: 'Cancel',
                                      positiveText: 'Yes',
                                      onAccept: (c) async {
                                        await deleteAccount(userid: getIntAsync(USER_ID));
                                        push(const SignInScreen(isfirst: false), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                                      },
                                      title: 'Are You Sure you wants to close your account' '?',
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                  ],
                ),
              ],
            ),
          ),
      ),
    );
  }

}