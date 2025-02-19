import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/screen/editprofile.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:stoneindia/widget/cataloguefilter.dart';





class TopNameWidget extends StatelessWidget {
  const TopNameWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: boxDecorationWithShadow(
          borderRadius: radius(0),
          backgroundColor: scaffoldBgColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                2.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset("assets/icons/hi.png", width: 22, height: 22, fit: BoxFit.cover),
                            8.width,
                            Text('Hi',
                              style: primaryTextStyle(color: secondaryTxtColor),
                            ),
                          ],
                        ),
                        8.height,
                        Text(' ${getStringAsync(FIRST_NAME).toString()} ${getStringAsync(LAST_NAME).toString()}', style: boldTextStyle(size: 20)),
                      ],
                    ),
                    getStringAsync(PROFILE_IMAGE).isNotEmpty
                        ? Container(
                      child: Row(
                        children: [
                          Container(
                            child:
                            Image.asset(
                              "assets/icons/filter.png",
                              height: 25,
                              width: 25,
                              color: kPrimaryColor,
                            ).onTap(() {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor:kBackgroundColor,
                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                                  builder: (context) => SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.85,
                                        child: const Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: CatalogueFilterDailog(),
                                        )
                                    )
                              );
                            }),
                          ),
                          // 10.width,
                          // Container(
                          //   child:
                          //     Image.asset(
                          //       "assets/icons/ringing.png",
                          //       height: 35,
                          //       width: 35,
                          //       color: kPrimaryColor,
                          //     ).onTap(() {
                          //       NotificationScreen().launch(context);
                          //     }),
                          // ),
                          10.width,
                          Container(
                            decoration: boxDecorationWithShadow(
                              border: Border.all(color: white, width: 4),
                              spreadRadius: 0,
                              blurRadius: 0,
                              boxShape: BoxShape.circle,
                            ),
                            child: cachedImage(
                              getStringAsync(PROFILE_IMAGE),
                              fit: BoxFit.cover,
                              height: 47,
                              width: 47,
                              alignment: Alignment.center,
                            ).cornerRadiusWithClipRRect(100).onTap(() {
                              const EditProfileScreen().launch(context);
                            }),

                          ),

                        ]

                      ),
                    )
                        :
            Container(
                      child: Row(
                        children: [
                          Container(
                            child:
                            Image.asset(
                              "assets/icons/filter.png",
                              height: 25,
                              width: 25,
                              color: kPrimaryColor,
                            ).onTap(() {
                              // CatalogueFilterDailog().launch(context);
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor:kBackgroundColor,
                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                                  builder: (context) => SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.85,
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: CatalogueFilterDailog(),
                                      )
                                  )
                              );
                            }),
                          ),
                          10.width,
                          // Container(
                          //   child:
                          //   Image.asset(
                          //     "assets/icons/ringing.png",
                          //     height: 35,
                          //     width: 35,
                          //     color: kPrimaryColor,
                          //   ).onTap(() {
                          //     NotificationScreen().launch(context);
                          //   }),
                          // ),
                          // 10.width,
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: boxDecorationWithShadow(
                              border: Border.all(color: white, width: 4),
                              backgroundColor: kPrimaryColor,
                              spreadRadius: 0,
                              blurRadius: 0,
                              boxShape: BoxShape.circle,
                            ),
                            child: (getStringAsync(FIRST_NAME).validate().isNotEmpty || getStringAsync(LAST_NAME).validate().isNotEmpty)
                                  ? Text(
                                '${getStringAsync(FIRST_NAME).validate()[0]}${getStringAsync(LAST_NAME).validate()[0]}'.toUpperCase(),
                                style: primaryTextStyle(color: textPrimaryWhiteColor, size: 16),
                              ).center()
                                  : Text('SB',
                                style: primaryTextStyle(color: textPrimaryWhiteColor, size: 16),
                              ).center(),
                          ).cornerRadiusWithClipRRect(defaultRadius).onTap(
                                () {
                                  const EditProfileScreen().launch(context);
                            },
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              ],
            ).expand(),
          ],
        ).paddingSymmetric(horizontal: 12, vertical: 8),
      );
  }
}
