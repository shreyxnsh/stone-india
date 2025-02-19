import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/screen/SBTeam/sbteamdashboard.dart';
import 'package:stoneindia/screen/signup.dart';
import 'package:stoneindia/utils/notification_send.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:translator/translator.dart';
import 'SBCustomer/sbcustomerdashboard.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SignInScreen extends StatefulWidget {
  final bool? isfirst;
  const SignInScreen({Key? key, this.isfirst}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var formKey = GlobalKey<FormState>();
  bool isfirst = false;
  String? number;
  bool isLoading = false;
  String? country_code;
  String country_iso_code = 'IN';
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    isfirst = widget.isfirst!;
    print("ISFIRST: $isfirst");
    init();
  }

  init() async {
    setStatusBarColor(scaffoldBgColor);
    NotificationSend.registerNotification();
  }

  getTranslatedName(String? name) async {
    String translatedText = '';
    if (name == null) {
      return translatedText;
    } else {
      translatedText = translator
          .translate(name, to: 'en')
          .then((result) => print("Source: $name\nTranslated: $result"))
          .toString();
      return translatedText;
    }
    return translatedText;
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      print('permission denied');
    } else {
      final contacts = await ContactsService.getContacts();
      print("sss");
      final contactList = contacts.map((contact) {
        return {
          'displayName': contact.displayName,
          'phones': contact.phones
                      ?.map((phone) => phone.value?.replaceAll(' ', ''))
                      .toList() ==
                  null
              ? ""
              : contact.phones!
                      .map((phone) => phone.value?.replaceAll(' ', ''))
                      .toList()
                      .isNotEmpty
                  ? contact.phones
                      ?.map((phone) => phone.value?.replaceAll(' ', ''))
                      .toList()
                      .first
                      .toString()
                  : "",
          'emails': contact.emails?.map((email) => email.value).toList() == null
              ? ""
              : contact.emails!.map((email) => email.value).toList().isNotEmpty
                  ? contact.emails
                      ?.map((email) => email.value)
                      .toList()
                      .first
                      .toString()
                  : "",
          //"translatedName": getTranslatedName(contact.displayName)
        };
      }).toList();

      Map req = {
        'user_id': "${getIntAsync(USER_ID)}",
      };
      final jsonData = jsonEncode(contactList);
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/contacts.json');
      try {
        await file.writeAsString(jsonData);
        if (file.existsSync()) {
          // final read = await file.readAsString();
          // print(read);
          // return jsonDecode(read);

          await sendContactJsonFile(req, filePath: file.path).then((value) {
            print("ok");
          }).onError((error, stackTrace) {
            print("errr");
            print(error.toString());
          });
        }
      } catch (e) {
        print('Tried writing _file error: $e');
      }
    }
  }

  saveForm() async {
    print(number);
    if (number == null) {
      toast("Please enter valid number!");
      return;
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      setState(() {});
      Map req = {
        'whatsapp_number': number.toString().replaceAll("+", ""),
        'fcm_token': getStringAsync(FCM_TOKEN).toString(),
        'country_code': country_code.validate().replaceAll("+", ""),
        'country_iso_code': country_iso_code.validate(),
      };
      setState(() {
        isLoading = true;
      });
      await login(req).then((value) async {
        if (value["status"] == true &&
            value["messages"] == "Login successfully!" &&
            value['role'] == "customer") {
          setValue(IS_LOGGED_IN, true);
          setValue(USER_ID, value["data"]["id"]);
          setValue(FIRST_NAME, value["data"]["firstname"]);
          setValue(LAST_NAME, value["data"]["lastname"]);
          setValue(USER_MOBILE, value["data"]["whatsapp_number"]);
          setValue(USER_ROLE, value["data"]["role"]);
          setValue(USER_DISPLAY_NAME,
              value["data"]["firstname"] + " " + value["data"]["lastname"]);
          if (value["data"]["profile_img"] != null) {
            setValue(PROFILE_IMAGE, value["data"]["profile_img"]);
          }
          // if(isfirst == true){

          // await _fetchContacts();
          toast('Login Successfully');
          setState(() {
            isLoading = false;
          });

          // }
          const SBCustomerDashboard(
                  runHomeApi: true, isfilter: false, isfirst: true)
              .launch(context,
                  isNewTask: true,
                  pageRouteAnimation: PageRouteAnimation.Slide);
        } else if (value["status"] == true &&
            value["messages"] == "Login successfully!" &&
            value['role'] == "team") {
          setValue(IS_LOGGED_IN, true);
          setValue(USER_ID, value["data"]["id"]);
          setValue(FIRST_NAME, value["data"]["firstname"]);
          setValue(LAST_NAME, value["data"]["lastname"]);
          setValue(USER_MOBILE, value["data"]["whatsapp_number"]);
          setValue(USER_ROLE, value["data"]["role"]);
          setValue(USER_DISPLAY_NAME,
              value["data"]["firstname"] + " " + value["data"]["lastname"]);
          if (value["data"]["profile_img"] != null) {
            setValue(PROFILE_IMAGE, value["data"]["profile_img"]);
          }
          setState(() {
            isLoading = false;
          });
          toast('Login Successfully');
          const SBTeamDashboard(runHomeApi: true, isfilter: false).launch(
              context,
              isNewTask: true,
              pageRouteAnimation: PageRouteAnimation.Slide);
        } else if (value["status"] == false) {
          toast(value["messages"].toString());
          setState(() {
            isLoading = false;
          });
        } else {
          errorToast('Wrong User');
          setState(() {
            isLoading = false;
          });
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        log(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    16.height,
                    Image.asset('assets/logo.png', height: 200, width: 200)
                        .center(),
                    RichTextWidget(
                      list: [
                        TextSpan(
                          text: appFirstName,
                          style: boldTextStyle(
                            size: 32,
                            letterSpacing: 1,
                            color: kPrimaryColor,
                          ),
                        ),
                        TextSpan(
                          text: appSecondName,
                          style: primaryTextStyle(
                            size: 32,
                            letterSpacing: 1,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ).center(),
                    32.height,
                    Text(
                      "SignIn To Continue",
                      style: secondaryTextStyle(
                          size: 14, color: textPrimaryBlackColor),
                    ).center(),
                    50.height,
                    Padding(
                      padding: const EdgeInsets.all(1),
                      child:
                          //          IntlPhoneField(
                          //   controller: phoneController,
                          //   dropdownTextStyle:Theme.of(context).textTheme.bodyMedium!.copyWith(
                          //       fontWeight: FontWeight.w600, color: FColors.primary) ,
                          //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          //       fontWeight: FontWeight.w600, color: FColors.primary),
                          //       textAlign: TextAlign.start,
                          //       dropdownIconPosition: IconPosition.trailing,
                          //   decoration: InputDecoration(
                          //     hintText: 'Enter your phone number',
                          //     hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          //       fontWeight: FontWeight.w600, color: FColors.primary),

                          //     border: const OutlineInputBorder(
                          //       borderSide: BorderSide(),
                          //     ),
                          //     filled: true,

                          //   ),
                          //   initialCountryCode: 'NG', // Default country code India
                          // ),

                          IntlPhoneField(
                        // disableLengthCheck: false,
                        cursorColor: kPrimaryColor,
                        decoration: textInputStyle(
                          context: context,
                          label: 'Whatsapp Number',
                          isMandatory: true,
                          suffixIcon: commonImage(
                            imageUrl: "assets/icons/user.png",
                            size: 10,
                          ),
                        ),
                        initialCountryCode: country_iso_code,
                        onChanged: (phone) {
                          setState(() {
                            number = phone.completeNumber;
                            country_code = phone.countryCode;
                            country_iso_code = phone.countryISOCode;
                          });
                        },
                      ),
                    ),
                    24.height,
                    if (isLoading == true)
                      AppButton(
                          width: context.width(),
                          shapeBorder:
                              RoundedRectangleBorder(borderRadius: radius()),
                          onTap: () {
                            toast("Please wait! Loading..");
                          },
                          color: kPrimaryColor,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sign In",
                                  style: boldTextStyle(
                                      color: textPrimaryWhiteColor)),
                              10.width,
                              const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            ],
                          )),
                    if (isLoading == false)
                      AppButton(
                        width: context.width(),
                        shapeBorder:
                            RoundedRectangleBorder(borderRadius: radius()),
                        onTap: () async {
                          saveForm();
                        },
                        color: kPrimaryColor,
                        padding: const EdgeInsets.all(16),
                        child: Text("Sign In",
                            style: boldTextStyle(color: textPrimaryWhiteColor)),
                      ),
                    32.height,
                    loginRegisterWidget(
                      context,
                      title: "New Member",
                      subTitle: "Sign Up",
                      onTap: () {
                        const SignUpScreen().launch(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
