import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/screen/SBTeam/sbteamblockscreen.dart';
import 'package:stoneindia/screen/SBTeam/sbteamhome.dart';
import 'package:stoneindia/screen/SBTeam/sbteamsetting.dart';
import 'package:stoneindia/widget/topname.dart';

class SBTeamDashboard extends StatefulWidget {
  final bool? runHomeApi;
  final bool? isfilter;
  final String? typeSelected;
  final String? productSelected;
  final String? blockSelected;
  final String? categorySelected;
  final String? slabSelected;
  final String? thicknessSelected;
  final String? date;
  const SBTeamDashboard(
      {super.key,
      this.runHomeApi,
      this.isfilter,
      this.typeSelected,
      this.productSelected,
      this.blockSelected,
      this.categorySelected,
      this.slabSelected,
      this.thicknessSelected,
      this.date});

  @override
  _SBTeamDashboardState createState() => _SBTeamDashboardState();
}

class _SBTeamDashboardState extends State<SBTeamDashboard> {
  int currentIndex = 0;
  double iconSize = 24;
  bool runHomeApi = false;
  bool isfilter = false;

  @override
  void initState() {
    super.initState();
    runHomeApi = widget.runHomeApi!;
    isfilter = widget.isfilter!;
    init();
  }

  init() async {
    setStatusBarColor(scaffoldBgColor);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              const TopNameWidget().visible(currentIndex == 0),
              Container(
                margin: EdgeInsets.only(top: currentIndex == 0 ? 70 : 0),
                child: [
                  SBTeamBlockScreen(
                      runHomeApi: runHomeApi,
                      isfilter: isfilter,
                      typeSelected: widget.typeSelected,
                      productSelected: widget.productSelected,
                      blockSelected: widget.blockSelected,
                      categorySelected: widget.categorySelected,
                      slabSelected: widget.slabSelected,
                      thicknessSelected: widget.thicknessSelected,
                      date: widget.date),
                  const SBTeamMenuScreen(),
                  const SBTeamSettingScreen()
                ][currentIndex],
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (i) {
              currentIndex = i;
              setState(() {
                runHomeApi = false;
                currentIndex = i;
              });
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            // selectedItemColor: kPrimaryColor,
            backgroundColor: kPrimaryColor, //Theme.of(context).cardColor,
            mouseCursor: MouseCursor.uncontrolled,
            fixedColor: kTextLightColor,
            elevation: 12,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/block.png',
                  height: iconSize,
                  width: iconSize,
                  color: Colors.white,
                ),
                activeIcon: Image.asset(
                  'assets/icons/blockfill.png',
                  height: iconSize,
                  width: iconSize,
                  color: Colors.white,
                ),
                label: 'Block',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/menu.png',
                  height: iconSize,
                  width: iconSize,
                  color: Colors.white,
                ),
                activeIcon: Image.asset(
                  'assets/icons/menufill.png',
                  height: iconSize,
                  width: iconSize,
                  color: Colors.white,
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/profile.png',
                  height: iconSize,
                  width: iconSize,
                  color: Colors.white,
                ),
                activeIcon: Image.asset(
                  "assets/icons/profilefill.png",
                  height: iconSize,
                  width: iconSize,
                  color: Colors.white,
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
