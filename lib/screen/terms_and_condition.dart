import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';

class TandCScreen extends StatefulWidget {
  const TandCScreen({super.key});

  @override
  _TandCScreenState createState() => _TandCScreenState();
}

class _TandCScreenState extends State<TandCScreen> {
  bool isLoading = false;
  var termsAndCondition = "";
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    setStatusBarColor(scaffoldBgColor, statusBarIconBrightness: Brightness.light);
    fetchTermsAndCondition().then((value){
      if(value["status"] == true){
        setState(() {
          termsAndCondition = value["data"]["description"].toString();
        });
      }
      setState(() {
        isLoading = false;
      });

    }).catchError((e){
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(kLightBackgroundColor, statusBarIconBrightness: Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: appAppBar(context, name: 'Terms & Condition'),
          body: isLoading == true
              ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
                strokeWidth: 2,
              ),
            ),
          )
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$appName T&C", style: primaryTextStyle(size: 30)),
                16.height,
                Container(
                  decoration: BoxDecoration(color: kPrimaryColor, borderRadius: radius(4)),
                  height: 4,
                  width: 200,
                ),
                16.height,
                Text(
                  termsAndCondition,
                  style: primaryTextStyle(size: 14),
                  textAlign: TextAlign.justify,
                ),
                16.height,

              ],
            ).paddingAll(16),
          )
      ),
    );
  }
}
