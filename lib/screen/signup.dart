import 'dart:convert';
import 'dart:io';
import 'dart:developer' as dev;

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/main.dart';
import 'package:stoneindia/screen/SBCustomer/sbcustomerdashboard.dart';
import 'package:stoneindia/screen/SBTeam/sbteamdashboard.dart';
import 'package:stoneindia/screen/otpscreen.dart';
import 'package:stoneindia/screen/signin.dart';
import 'package:stoneindia/utils/notification_send.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/utils/s_navigate.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:translator/translator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();

  final translator = GoogleTranslator();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  bool isLoading = false;
  bool? rememberMe = false;
  String? number;
  bool isLoginFirst = flowStats['login-first'] ?? false;
  bool isValidNumber = false;

  String? country_code;
  String? country_iso_code = 'IN';

  getTranslatedName() async {
    String translatedText = '';
    String firstName = firstNameCont.text;
    String lastName = lastNameCont.text;
    String input = "$firstName $lastName";
    translatedText = translator
        .translate(input, to: 'en')
        .then((result) => print("Source: $input\nTranslated: $result"))
        .toString();
    return translatedText;
    return translatedText;
  }

  Future<void> getLoginFirst() async {
    Map<String, dynamic> responseData = await authPermissionAPI();
    if (responseData['isSuccess'] == true) {
      isLoginFirst = responseData['login-first'];
      log("isLoginFirst: $isLoginFirst");
    }
    setState(() {});
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

  signUp() async {
    // navigate to otpscree
    log("I am here");
    if (number == null) {
      toast("Please enter valid details!");
      return;
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      setState(() {
        isLoading = true;
      });

      Map request = {
        "firstname": firstNameCont.text.validate(),
        "lastname": lastNameCont.text.validate(),
        "whatsapp_number": number.validate().replaceAll("+", ""),
        "country_code": country_code.validate().replaceAll("+", ""),
        "country_iso_code": country_iso_code.validate(),
        "fcm_token": getStringAsync(FCM_TOKEN).toString(),
        "role": "customer",
        // "translated_name": getTranslatedName()
      };
      await register(request).then((value) async {
        // log("I am here-----");
        print("RESPONSE: $value");
        if (value["status"] == true ||
            value["messages"].toString().contains("Successful")) {
          // finish(context, true);
          log("I am success-----");
          successToast(value["messages"].toString());
          log("I am success message-----");

          Map req = {
            'whatsapp_number': number.toString().replaceAll("+", ""),
            'fcm_token': getStringAsync(FCM_TOKEN).toString(),
            'country_code': country_code.validate().replaceAll("+", ""),
            'country_iso_code': country_iso_code.validate(),
          };
          log("I am success request-----");
          log(req.toString());
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
              // const SBCustomerDashboard(
              //         runHomeApi: true, isfilter: false, isfirst: true)
              //     .launch(context,
              //         isNewTask: true,
              //         pageRouteAnimation: PageRouteAnimation.Slide);

              StoneNavigate.toAndRemoveUntil(const SBCustomerDashboard(
                  runHomeApi: true, isfilter: false, isfirst: true));
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
              // const SBTeamDashboard(runHomeApi: true, isfilter: false).launch(
              //     context,
              //     isNewTask: true,
              //     pageRouteAnimation: PageRouteAnimation.Slide);

              StoneNavigate.toAndRemoveUntil(
                const SBTeamDashboard(
                  runHomeApi: true,
                  isfilter: false,
                ),
              );
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
          log("I am success launch-----");
        } else {
          toast(value["messages"].toString());
        }
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        log("I am error-----");
        errorToast(e.toString());
        setState(() {
          isLoading = false;
        });
      }).whenComplete(() {
        log("I am complete -----");
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    NotificationSend.registerNotification();
    getLoginFirst();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    firstNameCont.dispose();
    lastNameCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldBgColor,
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo.png', height: 200, width: 200),
                        16.height,
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
                        AppTextField(
                          textStyle: primaryTextStyle(color: darkerText),
                          controller: firstNameCont,
                          textFieldType: TextFieldType.NAME,
                          decoration: textInputStyle(
                            context: context,
                            label: 'First Name',
                            isMandatory: true,
                            suffixIcon: commonImage(
                              imageUrl: "assets/icons/user.png",
                              size: 10,
                            ),
                          ),
                          focus: firstNameFocus,
                          errorThisFieldRequired: "First Name Is Required",
                          nextFocus: lastNameFocus,
                        ),
                        16.height,
                        AppTextField(
                          textStyle: primaryTextStyle(color: darkerText),
                          controller: lastNameCont,
                          textFieldType: TextFieldType.NAME,
                          decoration: textInputStyle(
                            context: context,
                            label: 'Last Name',
                            isMandatory: true,
                            suffixIcon: commonImage(
                              imageUrl: "assets/icons/user.png",
                              size: 10,
                            ),
                          ),
                          focus: lastNameFocus,
                          errorThisFieldRequired: 'Last Name Is Required',
                        ),
                        16.height,
                        Padding(
                          padding: const EdgeInsets.all(1),
                          child: IntlPhoneField(
                            disableLengthCheck: false,
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
                                // country_name_code = phone.countryISOCode;
                                number = phone.completeNumber;
                                country_code = phone.countryCode;
                                country_iso_code = phone.countryISOCode;
                                isValidNumber = phone.isValidNumber();
                              });
                            },
                          ),
                        ),
                        40.height,
                        AppButton(
                          width: context.width(),
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: radius(),
                          ),
                          onTap: isLoading == true
                              ? null
                              : () async {
                                  if (number == null) {
                                    toast("Please enter valid details!");
                                    return;
                                  }
                                  if (number!.length < 10) {
                                    toast("Please enter valid number!");
                                    return;
                                  }
                                  if (firstNameCont.text.isEmpty ||
                                      lastNameCont.text.isEmpty ||
                                      number!.isEmpty) {
                                    toast("Please enter valid details!");
                                    return;
                                  }
                                  if (isLoading == true) {
                                    return;
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });

                                  bool authPermissionGranted = false;

                                  Map<String, dynamic> authPermissionResult =
                                      await authPermissionAPI();

                                  if (authPermissionResult['isSuccess'] ==
                                      true) {
                                    if (!authPermissionResult['phone-auth']) {
                                      signUp();
                                      setState(() {
                                        isLoading = false;
                                      });
                                      return;
                                    }
                                  }

                                  // snackBar(
                                  //   context,
                                  //   title: "Logging in, please wait...",
                                  //   snackBarAction: SnackBarAction(
                                  //     label: 'Ok',
                                  //     onPressed: () {
                                  //       // dismiss
                                  //       ScaffoldMessenger.of(context)
                                  //           .hideCurrentSnackBar();
                                  //     },
                                  //   ),
                                  // );

                                  Map req = {
                                    'whatsapp_number':
                                        number.toString().replaceAll("+", ""),
                                    'fcm_token':
                                        getStringAsync(FCM_TOKEN).toString(),
                                    'country_code': country_code
                                        .validate()
                                        .replaceAll("+", ""),
                                    'country_iso_code':
                                        country_iso_code.validate(),
                                  };
                                  bool isUserExists = false;
                                  await login(req).then((value) async {
                                    if (value["status"] == true &&
                                        value["messages"] ==
                                            "Login successfully!" &&
                                        value['role'] == "customer") {
                                      isUserExists = true;
                                      toastLong('User already exists');
                                    }
                                  }).catchError((e) {});

                                  if (isUserExists) {
                                    // toast("User already exists");
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          const Text("User already exists"),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {},
                                      ),
                                    ));

                                    return;
                                  }

                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  // await auth.setSettings(
                                  //     appVerificationDisabledForTesting: true);
                                  await auth.verifyPhoneNumber(
                                    phoneNumber: number!,
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) async {
                                      await auth
                                          .signInWithCredential(credential);
                                      print("Automatic Verification Done");
                                    },
                                    verificationFailed:
                                        (FirebaseAuthException e) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      print(
                                          "Verification Failed: ${e.message}");
                                    },
                                    codeSent: (String verificationId,
                                        int? resendToken) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Otpscreen(
                                            mobile: number!,
                                            verificationId: verificationId,
                                            onVerificationDone: () async {
                                              await signUp();
                                            },
                                          ),
                                        ),
                                      );
                                      print("OTP Sent");
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      print("Timeout");
                                    },
                                    //
                                  );
                                  //  setState(() {
                                  //   isLoading = false;
                                  // });

                                  // await signUp();
                                },
                          color: kPrimaryColor,
                          disabledColor: kPrimaryColor.withAlpha(200),
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            height: 24,
                            width: isLoading ? 24 : null,
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text("Sign Up",
                                    style: boldTextStyle(
                                        color: textPrimaryWhiteColor)),
                          ),
                        ),
                        24.height,
                        loginRegisterWidget(context,
                            title: 'Already A Member',
                            subTitle: 'Login', onTap: () {
                          // const SignInScreen(
                          //   isfirst: false,
                          // ).launch(context, isNewTask: true);

                          StoneNavigate.toAndRemoveUntil(
                            const SignInScreen(
                              isfirst: false,
                            ),
                          );
                        }),
                        24.height,
                      ],
                    ),
                  ).center(),
                  Visibility(
                    visible: !isLoginFirst,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          // pop context
                          // const SBCustomerDashboard(
                          //         runHomeApi: true,
                          //         isfilter: false,
                          //         isfirst: true)
                          //     .launch(context, isNewTask: true);

                          StoneNavigate.toAndRemoveUntil(
                            const SBCustomerDashboard(
                              runHomeApi: true,
                              isfilter: false,
                              isfirst: true,
                            ),
                          );
                        },
                        child: Text(
                          "Skip",
                          style: primaryTextStyle(
                              size: 16, color: black, weight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
