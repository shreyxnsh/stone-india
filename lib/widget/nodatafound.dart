import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String? text;
  final double? iconSize;

  const NoDataFoundWidget({super.key, this.text, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/noDataFound.png",
          height: iconSize ?? 180,
          fit: BoxFit.fitHeight,
        ),
        Text(text ?? 'No Match', style: boldTextStyle(size: 18)),
        8.height.visible(false),
        Text(
          'No Data SubTitle',
          textAlign: TextAlign.center,
          style: secondaryTextStyle(color: secondaryTxtColor),
        ).visible(false),
      ],
    ).paddingAll(16);
  }
}
