import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';

class AppSettingItemWidget extends StatelessWidget {
  final String? name;
  final String? subTitle;
  final Widget? wSubTitle;
  final Widget? icon;
  final String? image;
  final Function? onTap;
  final Widget? widget;
  final bool isNotTranslate;

  const AppSettingItemWidget({super.key, this.name, this.subTitle, this.wSubTitle, this.icon, this.image, this.onTap, this.widget, this.isNotTranslate = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget == null
            ? onTap as void Function()?
            : () {
          widget.launch(context);
        },
        child: Container(
          width: context.width() / 2 - 24,
          padding: const EdgeInsets.all(16),
          decoration: boxDecorationWithShadow(
            borderRadius: BorderRadius.circular(defaultRadius),
            backgroundColor: Theme.of(context).cardColor,
            blurRadius: 0,
            spreadRadius: 0,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "$image",
                    height: 35,
                    width: 35,
                    color: kPrimaryColor,
                  ).visible(
                    image != null,
                    defaultWidget: icon,
                  ),
                  16.height,
                  Text(name.toString(), style: boldTextStyle(size: 16)),
                  8.height,
                  Text(
                    isNotTranslate != false ? subTitle.validate() : subTitle.toString(),
                    style: secondaryTextStyle(size: 12, color: secondaryTxtColor),
                  ).visible(
                    subTitle != null,
                    defaultWidget: wSubTitle,
                  ),
                ],
              ).expand(),
            ],
          ),
        ),
      );
  }
}
