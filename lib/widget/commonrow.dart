import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';

class CommonRowWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final bool isMarquee;

  const CommonRowWidget({super.key, required this.title, required this.value, this.isMarquee = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.antiAlias,
          fit: BoxFit.scaleDown,
          child: Text(title, style: secondaryTextStyle(color: secondaryTxtColor, size: 16)),
        ).expand(
        ),
        (isMarquee
            ? Marquee(
          child: Text(value, ),
        )
            : Text(value, ))
            .expand(flex: 1),
      ],
    );
  }
}
