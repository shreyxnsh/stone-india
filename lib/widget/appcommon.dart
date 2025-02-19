import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

void setDynamicStatusBarColor({Color? color}) {
  if (color != null) {
    setStatusBarColor(color);
  } else {
    setStatusBarColor(Colors.white);
  }
}

Widget loginRegisterWidget(BuildContext context,
    {String? title, String? subTitle, Function()? onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(title.validate(), style: secondaryTextStyle()),
      TextButton(
        onPressed: onTap,
        child: Text(subTitle.validate(),
            style: primaryTextStyle(
                color: kPrimaryColor,
                size: 16,
                decoration: TextDecoration.none)),
      )
    ],
  );
}

bool isLoading = false;
Future<void> setLoading(bool value) async => isLoading = value;

void errorToast(String e) {
  toast(e, bgColor: errorBackGroundColor, textColor: errorTextColor);
}

void successToast(String? e) {
  toast(e, bgColor: successBackGroundColor, textColor: successTextColor);
}

Widget commonImage({String? imageUrl, double? size, BoxFit? fit}) {
  return Image.asset(
    imageUrl.validate(),
    width: size ?? 24,
    height: size ?? 24,
    fit: fit ?? BoxFit.cover,
    color: kSecondaryColor,
  ).paddingAll(16);
}

InputDecoration textInputStyle(
    {required BuildContext context,
    String? label,
    bool isMandatory = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? text,
    String prefixText = ''}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(8),
    fillColor: Colors.white,
    filled: true,
    labelStyle: secondaryTextStyle(color: secondaryTxtColor),
    hintStyle: secondaryTextStyle(color: secondaryTxtColor),
    hintText: '',
    prefixText: prefixText,
    suffixIcon: suffixIcon,
    suffixIconColor: context.iconColor,
    prefixStyle: primaryTextStyle(),
    alignLabelWithHint: true,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelText: text ??
        (label.validate().isNotEmpty ? '$label${isMandatory ? '*' : ''}' : ''),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 0.5),
      borderRadius: radius(),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent, width: 0.5),
      borderRadius: radius(),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 0.5, color: Colors.transparent),
      borderRadius: radius(),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(width: 0.5, color: Colors.transparent),
      borderRadius: radius(),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent, width: 0.5),
      borderRadius: radius(),
    ),
  );
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Widget setLoader() {
  return Loader(
    valueColor: AlwaysStoppedAnimation(
      defaultLoaderAccentColorGlobal ?? primaryColor,
    ),
  );
}

Widget cachedImage(String? url,
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    bool usePlaceholderIfUrlEmpty = true,
    double? radius}) {
  print(url);
  if (url.validate().isEmpty) {
    return placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius);
  } else if (url.validate().startsWith('http') ||
      url.validate().startsWith('https')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return const SizedBox();
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
    );
  } else {
    return Image.asset(url!,
            height: height,
            width: width,
            fit: fit,
            alignment: alignment ?? Alignment.center)
        .cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget(
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    double? radius}) {
  return Image.asset('assets/placeholder.jpg',
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center)
      .cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Future<void> launchUrl(String url, {bool forceWebView = false}) async {
  await launch(url,
          forceWebView: forceWebView,
          enableJavaScript: true,
          statusBarBrightness: Brightness.light)
      .catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}

class AddFloatingButton extends StatelessWidget {
  final Widget? navigate;
  final Function? onTap;
  final IconData? icon;

  const AddFloatingButton({super.key, this.navigate, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: kPrimaryColor,
      child: Icon(
        icon ?? Icons.add,
        color: Colors.white,
      ),
      onPressed: () => navigate == null
          ? onTap!.call()
          : navigate.launch(context,
              pageRouteAnimation: PageRouteAnimation.Slide),
    );
  }
}

Widget noDataWidget({String? text, bool isInternet = false}) {
  return Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
            isInternet ? 'assets/no_internet.png' : 'assets/noFound.png',
            height: 100,
            fit: BoxFit.fitHeight),
        8.height,
        Text(text.validate(value: 'No Data'), style: boldTextStyle(size: 16))
            .center(),
      ],
    ).center(),
  );
}

AppBar appImageBar(BuildContext context,
    {String? name,
    Function? filter,
    Function? reload,
    Widget? leading,
    Color? backgroundColor,
    List<Widget>? actions,
    double? elevation}) {
  return AppBar(
    actions: [
      IconButton(
        onPressed: () async {
          await filter!();
        },
        icon: Image.asset('assets/icons/filter.png', height: 20, width: 20),
      ),
      IconButton(
        onPressed: () async {
          await reload!();
        },
        icon: Image.asset('assets/icons/reload.png', height: 20, width: 20),
      ),
    ],
    leading: leading ??
        IconButton(
          color: darkerText,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            finish(context);
          },
        ),
    elevation: elevation.validate(value: 0.0),
    shadowColor: shadowColorGlobal,
    backgroundColor: scaffoldBgColor,
    title: Text(
      name.validate(value: 'Name Is Missing'),
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          letterSpacing: 0.27,
          color: darkerText),
    ).center(),
    titleSpacing: 0,
  );
}

AppBar HeadingAppBar(BuildContext context,
    {String? name,
    Widget? leading,
    Color? backgroundColor,
    List<Widget>? actions,
    double? elevation}) {
  return AppBar(
    elevation: elevation.validate(value: 0.0),
    shadowColor: shadowColorGlobal,
    backgroundColor: scaffoldBgColor,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name.validate(value: 'Name Is Missing'),
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: darkerText),
          textAlign: TextAlign.center,
        )
      ],
    ),
    titleSpacing: 0,
  );
}

AppBar appAppBar(BuildContext context,
    {String? name,
    Widget? leading,
    Color? backgroundColor,
    List<Widget>? actions,
    double? elevation}) {
  return AppBar(
    actions: actions,
    leading: leading ??
        IconButton(
          color: darkerText,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            finish(context);
          },
        ),
    elevation: elevation.validate(value: 0.0),
    shadowColor: shadowColorGlobal,
    backgroundColor: scaffoldBgColor,
    title: Text(
      name.validate(value: 'Name Is Missing'),
      style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          letterSpacing: 0.27,
          color: darkerText),
    ),
    titleSpacing: 0,
  );
}
