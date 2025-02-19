import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/screen/signup.dart';

class WalkThroughModel {
  String? image;
  String? title;
  String? subTitle;

  WalkThroughModel({this.image, this.title, this.subTitle});
}

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({super.key});

  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  var selectedIndex = 0;
  PageController pageController = PageController();

  List<WalkThroughModel> list = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(scaffoldBgColor);

    list.add(WalkThroughModel(
      image: "assets/walkThrough1.png",
      title: 'Marble Emporium',
      subTitle: 'Discover Timeless Luxury for Your Spaces.',
    ));
    list.add(WalkThroughModel(
      image: "assets/walkThrough2.png",
      title: 'Marble Masterpieces',
      subTitle: 'Elevate Your Interiors with Exquisite Craftsmanship.',
    ));
    list.add(WalkThroughModel(
      image: "assets/walkThrough3.png",
      title: 'The Marble Collection',
      subTitle: 'Unleash the Elegance of Natural Stone.',
    ));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: pageController,
              children: list.map((e) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(e.image!), fit: BoxFit.fill)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Column(
                      children: [
                        Text(e.title!,
                                textAlign: TextAlign.left,
                                style: boldTextStyle(size: 60).copyWith(
                                    background: Paint()
                                      ..color = Colors.white70))
                            .paddingOnly(left: 20),
                        // 25.height,
                        Text(
                          e.subTitle!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                              background: Paint()..color = Colors.white70),
                        ).paddingOnly(left: 20),

                        // Image.asset(e.image!, height: context.height() * 0.55),
                        // Text(e.title!, style: boldTextStyle(size: 25)),
                        // Text(e.subTitle!, textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(32),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onPageChanged: (index) {
                selectedIndex = index;
                setState(() {});
              },
            ),
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: DotIndicator(
                pageController: pageController,
                pages: list,
                indicatorColor: kSecondaryColor,
              ),
            ),
            Positioned(
              right: 20,
              left: 150,
              bottom: 35,
              child: AnimatedCrossFade(
                sizeCurve: Curves.fastLinearToSlowEaseIn,
                firstChild: Container(
                  width: context.width(),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: kPrimaryColor,
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Get Started',
                              style: boldTextStyle(color: Colors.white))
                          .center()
                          .expand(),
                      const Icon(Icons.arrow_forward_outlined,
                          color: Colors.white),
                    ],
                  ),
                ).onTap(() {
                  setValue(IS_WALKTHROUGH_FIRST, true);
                  const SignUpScreen().launch(context);
                }),
                secondChild: const SizedBox(),
                duration: const Duration(milliseconds: 300),
                crossFadeState: selectedIndex == (list.length - 1)
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ),
            selectedIndex != (list.length - 1)
                ? Positioned(
                    right: 20,
                    left: 150,
                    bottom: 35,
                    child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            decoration: boxDecorationWithRoundedCorners(
                                backgroundColor: kPrimaryColor,
                                borderRadius:
                                    BorderRadius.circular(defaultRadius)),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Next',
                                        style:
                                            boldTextStyle(color: Colors.white))
                                    .center()
                                    .expand(),
                                const Icon(Icons.arrow_forward_outlined,
                                    color: Colors.white),
                              ],
                            ).center())
                        .onTap(() {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut);
                    }),
                  )
                : const SizedBox(),
            Positioned(
              left: 40,
              bottom: 40,
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Text('Skip', style: boldTextStyle()),
              ).onTap(
                () {
                  setValue(IS_WALKTHROUGH_FIRST, true);
                  const SignUpScreen().launch(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
