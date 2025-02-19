import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool isLoading = false;
  var heading = '';
  var version = '';
  var description = '';
  var features = '';
  var footer = '';

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
    aboutUs().then((value){
      if(value["status"] == true){
        setState(() {
          heading = value["data"]["heading"].toString();
          version = value["data"]["version"].toString();
          description = value["data"]["description"].toString();
          features = value["data"]["feature"].toString();
          footer = value["data"]["footer"].toString();
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
          appBar: appAppBar(context, name: 'About Us'),
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
                Text(heading.toString(), style: primaryTextStyle(size: 30)),
                16.height,
                Container(
                  decoration: BoxDecoration(color: kPrimaryColor, borderRadius: radius(4)),
                  height: 4,
                  width: 200,
                ),
                10.height,
                Text(
                  "Version - ${version.toString()}",
                  style: primaryTextStyle(size: 16),
                  textAlign: TextAlign.justify,
                ),
                24.height,
                Text("\r\nDescription\r\n", style: primaryTextStyle(size: 20)),
                Text(
                  description.toString(),
                  style: primaryTextStyle(size: 14),
                  textAlign: TextAlign.justify,
                ),
                16.height,
                Text("\r\nFeatures\r\n", style: primaryTextStyle(size: 20)),
                Text(
                  features.toString(),
                  style: primaryTextStyle(size: 14),
                  textAlign: TextAlign.justify,
                ),
                25.height,
                Text(
                  footer.toString(),
                  style: primaryTextStyle(size: 16),
                  textAlign: TextAlign.justify,
                ),
                30.height,
              ],
            ).paddingAll(16),
          )
      ),
    );
  }
}
