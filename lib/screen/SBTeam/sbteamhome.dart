import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/screen/SBTeam/bockscreen.dart';
import 'package:stoneindia/screen/SBTeam/categoryscreen.dart';
import 'package:stoneindia/screen/SBTeam/holdscreen.dart';
import 'package:stoneindia/screen/SBTeam/productscreen.dart';
import 'package:stoneindia/screen/SBTeam/slabscreen.dart';
import 'package:stoneindia/screen/SBTeam/soldscreen.dart';
import 'package:stoneindia/screen/SBTeam/thicknessscreen.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:stoneindia/widget/appsetting.dart';

class SBTeamMenuScreen extends StatefulWidget {
  const SBTeamMenuScreen({super.key});

  @override
  _SBTeamMenuScreenState createState() => _SBTeamMenuScreenState();
}

class _SBTeamMenuScreenState extends State<SBTeamMenuScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: HeadingAppBar(context, name: 'Menu'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(
                          height: 600,
                          margin: const EdgeInsets.only(top: 1),
                          child: const Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              AppSettingItemWidget(
                                  name: 'Block List',
                                  image: "assets/icons/blockk.png",
                                  widget: BlockScreen()
                              ),
                              AppSettingItemWidget(
                                  name: 'Product List',
                                  image: "assets/icons/box.png",
                                  widget: ProductScreen()
                              ),
                              AppSettingItemWidget(
                                  name: 'Category List',
                                  image: "assets/icons/package.png",
                                  widget: CategoryScreen()
                              ),
                              AppSettingItemWidget(
                                  name: 'Slab List',
                                  image: "assets/icons/product.png",
                                  widget: SlabScreen()
                              ),
                              AppSettingItemWidget(
                                  name: 'Hold List',
                                  image: "assets/icons/privacy.png",
                                  widget: HoldScreen()
                              ),
                              AppSettingItemWidget(
                                  name: 'Sold List',
                                  image: "assets/icons/sold.png",
                                  widget: SoldScreen()
                              ),
                              AppSettingItemWidget(
                                  name: 'Thickness List',
                                  image: "assets/icons/line-thickness.png",
                                  widget: ThicknessScreen()
                              ),
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