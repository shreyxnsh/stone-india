// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

const BASE_URL = 'https://easystone.co.in/api/';
String mBaseUrl = 'https://easystone.co.in/api/';

// list of colors that we use in our app
const kPrimaryColor = Color(0xFF32ACD1);//Color(0xFFF38d45);
const kLightBackgroundColor = Color(0xFFE6F6F6);
const selectAppointmentColor = Color(0xFF545DC1);
const selectBAppointmentColor = Color(0xFFEEF1FD);
const selectChatColor = Color(0xFFFEA77F);
const selectBChatColor = Color(0xFFFFDCC0);
const kBackgroundColor = Color(0xFFF5F9FA);
const kDarkButtonBg = Color(0xFF273546);
const kSecondaryColor = Color(0xFF808080);
const kSelectItemColor = Color(0xFF000000);
const kRedColor = Color(0xFFEC5252);
const kBlueColor = Color(0xFF68B0FF);
const kGreenColor = Color(0xFF43CB65);
const kGreenPurchaseColor = Color(0xFF2BD0A8);
const kToastTextColor = Color(0xFFEEEEEE);
const kTextColor = Color(0xFF273242);
const kTextLightColor = Color(0xFF000000);
const kTextLowBlackColor = Colors.black38;
const kStarColor = Color(0xFFEFD358);
const kDeepBlueColor = Color(0xFF594CF5);
const kTabBarBg = Color(0xFFEEEEEE);
const kDarkGreyColor = Color(0xFF757575);
const kTextBlueColor = Color(0xFF5594bf);
const kTimeColor = Color(0xFF366cc6);
const kTimeBackColor = Color(0xFFe3ebf5);
const kLessonBackColor = Color(0xFFf8e5d2);
// const kLightBlueColor = Color(0xFFE7EEFE);
const kLightBlueColor = Color(0xFF4AA8D4);
const kFormInputColor = Color(0xFFc7c8ca);
const kNoteColor = Color(0xFFbfdde4);
const kLiveClassColor = Color(0xFFfff3cd);
const kSectionTileColor = Color(0xFFdddcdd);
// Color of Categories card, long arrow
const iCardColor = Color(0xFFF4F8F9);
const iLongArrowRightColor = Color(0xFF559595);
Color selectedColor = getColorFromHex('#e6ecfa');
Color primaryColor = const Color(0xFF32ACD1);//Color(0xFFF38d45);
Color primaryDarkColor = const Color(0xff0a0909);
Color appPrimaryColor = primaryColor;
const appSecondaryColor = Color(0xFFF68685);
const scaffoldDarkColors = Color(0xff0a0909);
const cardDarkColors = Color(0xff232121);
const cardSelectedColor = Color(0xff3e3b3b);
const textPrimaryBlackColor = Color(0xFF000000);
const textSecondaryBlackColor = Color(0xFF575454);
const scaffoldBgColor = Color(0xFFF5F9FA);//Color(0xFFFEF4EC);
const statusBgColor = Color(0xFF5cc16c);
const profileBgColor = Color(0xFFD7E2F4);
const tabBgColor = Color(0xFF171C26);
const secondaryTxtColor = Color(0xFF6E7990);
const statusColor = Color(0xFF5CC16C);
const patientTxtColor = Color(0xFF6E7990);
const iconBgColor = Color(0xFF6E7990);
const disableButton = Color(0xFFACB5C2);
//Error Color
const errorBackGroundColor = Color(0xFFFFCDD2);
const errorTextColor = Colors.red;

//Error Color
const successBackGroundColor = Color(0xFFDCEDC8);
const successTextColor = Colors.green;

const greenbackGroundColor = Colors.green;

const textPrimaryWhiteColor = Color(0xFFF0F8FF);
const textSecondaryWhiteColor = Color(0xFFc7daeb);

// User Roles
const UserRoleStoneBharatTeam = 'team';
const UserRoleCustomer = 'customer';

const appName = 'StoneIndia';
const appFirstName = 'Stone';
const appSecondName = 'India';

// Shared preferences keys
const USER_NAME = 'USER_NAME';
const USER_PASSWORD = 'USER_PASSWORD';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_REMEMBER_ME = 'IS_REMEMBER_ME';
const USER_ID = "USER_ID";
const USER_DATA = "USER_DATA";
const FIRST_NAME = "FIRST_NAME";
const LAST_NAME = "LAST_NAME";
const USER_EMAIL = "USER_EMAIL";
const USER_LOGIN = "USER_LOGIN";
const USER_MOBILE = 'USER_MOBILE';
const USER_GENDER = 'USER_GENDER';
const USER_DISPLAY_NAME = "USER_DISPLAY_NAME";
const PROFILE_IMAGE = "PROFILE_IMAGE";
const PASSWORD = "PASSWORD";
const USER_ROLE = "USER_ROLE";
const IS_WALKTHROUGH_FIRST = "IS_WALKTHROUGH_FIRST";
const FCM_TOKEN = "FCM_TOKEN";
const tokenStream = 'tokenStream';
const PRODUCT_LIST = "PRODUCT_LIST";
const BLOCK_LIST = "BLOCK_LIST";
const THICKNESS_LIST = "THICKNESS_LIST";
const SLAB_LIST = "SLAB_LIST";
const CATEGORY_LIST = "CATEGORY_LIST";
const SERVER_PRODUCT_LIST = "SERVER_PRODUCT_LIST";
const SERVER_BLOCK_LIST = "SERVER_BLOCK_LIST";
const BLOCK_FORM = "BLOCK_FORM"; //customer
const BLOCK_FORM_LIST = "BLOCK_FORM_LIST"; //team
const BLOCK_FORM_LAST_ID = "BLOCK_FORM_LAST_ID";
const BLOCK_FORM_LIST_LAST_ID = "BLOCK_FORM_LIST_LAST_ID"; //team
const FILTER_LAST_ID = "FILTER_LAST_ID";
const FILTER_LIST_LAST_ID = "FILTER_LIST_LAST_ID"; //team
const TEAM_TOTAL_BLOCK_FORM_COUNT = "TEAM_TOTAL_BLOCK_FORM_COUNT";
const CUSTOMER_TOTAL_BLOCK_FORM_COUNT = "CUSTOMER_TOTAL_BLOCK_FORM_COUNT";
const CONVERT_DATE = 'yyyy-MM-dd';

int titleTextSize = 18;
//region THEME MODE TYPE
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;
//endregion

const Color notWhite = Color(0xFFEDF0F2);
const Color nearlyWhite = Color(0xFFFFFFFF);
const Color nearlyBlue = Color(0xFF42A29A);
const Color nearlyBlack = Color(0xFF213333);
const Color grey = Color(0xFF3A5160);
const Color dark_grey = Color(0xFF313A44);

const Color darkText = Color(0xFF253840);
const Color darkerText = Color(0xFF17262A);
const Color lightText = Color(0xFF4A6572);
const Color deactivatedText = Color(0xFF767676);
const Color dismissibleBackground = Color(0xFF364A54);
const Color chipBackground = Color(0xFFEEF1F3);
const Color spacer = Color(0xFFF2F2F2);


