import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/screen/SBCustomer/sbcustomerblock.dart';
import 'package:stoneindia/screen/SBCustomer/sbcustomersetting.dart';
import 'package:stoneindia/widget/topname.dart';

class SBCustomerDashboard extends StatefulWidget {
  final bool? runHomeApi;
  final bool? isfilter;
  final bool? isfirst;
  final String? typeSelected;
  final String? productSelected;
  final String? blockSelected;
  final String? categorySelected;
  final String? slabSelected;
  final String? thicknessSelected;
  const SBCustomerDashboard(
      {super.key,
      this.runHomeApi,
      this.isfilter,
      this.isfirst,
      this.typeSelected,
      this.productSelected,
      this.blockSelected,
      this.categorySelected,
      this.slabSelected,
      this.thicknessSelected});

  @override
  _SBCustomerDashboardState createState() => _SBCustomerDashboardState();
}

class _SBCustomerDashboardState extends State<SBCustomerDashboard> {
  int currentIndex = 0;
  Color disableIconColor = kPrimaryColor;
  double iconSize = 24;
  bool runHomeApi = false;
  bool isfilter = false;
  bool isfirst = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(scaffoldBgColor);
    runHomeApi = widget.runHomeApi!;
    isfilter = widget.isfilter!;
    isfirst = widget.isfirst!;
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
              const TopNameWidget().visible(currentIndex != 1),
              Container(
                margin: EdgeInsets.only(top: currentIndex != 1 ? 70 : 0),
                child: [
                  SBCustomerBlockScreen(
                      runHomeApi: runHomeApi,
                      isfilter: isfilter,
                      typeSelected: widget.typeSelected,
                      productSelected: widget.productSelected,
                      blockSelected: widget.blockSelected,
                      categorySelected: widget.categorySelected,
                      slabSelected: widget.slabSelected,
                      thicknessSelected: widget.thicknessSelected,
                      isfirst: isfirst),
                  const SBCustomerSettingScreen()
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
            backgroundColor: kPrimaryColor,
            mouseCursor: MouseCursor.uncontrolled,
            fixedColor: kTextLightColor,
            elevation: 12,
            items: [
              // BottomNavigationBarItem(
              //   icon: Image.asset('assets/icons/home.png', height: iconSize, width: iconSize),
              //   activeIcon: Image.asset('assets/icons/homefill.png', height: iconSize, width: iconSize),
              //   label: 'Dashboard',
              // ),
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
