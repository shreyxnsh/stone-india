import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/profile.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:translator/translator.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var formKey = GlobalKey<FormState>();
  var picked = DateTime.now();

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController stateCont = TextEditingController();
  TextEditingController countryCont = TextEditingController();
  final translator = GoogleTranslator();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  bool isSelected = false;
  bool isLoading = false;
  bool isFirst = true;

  String displayName = "";

  PickedFile? selectedImage;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(scaffoldBgColor, statusBarIconBrightness: Brightness.light);
  }

  @override
  void dispose() {
    setStatusBarColor(scaffoldBgColor);
    firstNameCont.dispose();
    lastNameCont.dispose();
    addressCont.dispose();
    cityCont.dispose();
    stateCont.dispose();
    countryCont.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    addressFocus.dispose();
    cityFocus.dispose();
    stateFocus.dispose();
    countryFocus.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future getImage() async {
    selectedImage = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      selectedImage = selectedImage;
    });
  }

  getTranslatedName() async{
    String translatedText = '';
    String firstName = firstNameCont.text;
    String lastName = lastNameCont.text;
    String input = "$firstName $lastName";
    translatedText = translator.translate(input, to: 'en').then((result) => print("Source: $input\nTranslated: $result")).toString();
    return translatedText;
      return translatedText;
  }

  @override
  Widget build(BuildContext context) {
    Widget body() {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.all(12),
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: profileBgColor, boxShape: BoxShape.circle),
                    child: selectedImage != null
                        ? Image.file(File(selectedImage!.path), height: 90, width: 90, fit: BoxFit.cover, alignment: Alignment.center).cornerRadiusWithClipRRect(180)
                        : getStringAsync(PROFILE_IMAGE).validate().isNotEmpty
                        ? cachedImage(getStringAsync(PROFILE_IMAGE), height: 90, width: 90, fit: BoxFit.cover, alignment: Alignment.center, ).cornerRadiusWithClipRRect(180)
                        : const Icon(Icons.person_outline_rounded).paddingAll(16),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: appPrimaryColor,
                        boxShape: BoxShape.circle,
                        border: Border.all(color: white, width: 3),
                      ),
                      child: Image.asset("assets/icons/camera.png", height: 14, width: 14, color: Colors.white),
                    ).onTap(() {
                      getImage();
                    }),
                  )
                ],
              ).paddingOnly(top: 16, bottom: 16),
              16.height,
              Row(
                children: [
                  AppTextField(
                    controller: firstNameCont,
                    focus: firstNameFocus,
                    nextFocus: lastNameFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: textInputStyle(context: context, label: 'First Name'),
                    scrollPadding: const EdgeInsets.all(0),
                  ).expand(),
                  10.width,
                  AppTextField(
                    controller: lastNameCont,
                    focus: lastNameFocus,
                    nextFocus: addressFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: textInputStyle(context: context, label: 'Last Name'),
                  ).expand(),
                ],
              ),
              16.height,
              AppTextField(
                controller: addressCont,
                focus: addressFocus,
                nextFocus: cityFocus,
                textFieldType: TextFieldType.ADDRESS,
                decoration: textInputStyle(context: context, label: 'Address').copyWith(alignLabelWithHint: true),
                maxLines: 1,
                textInputAction: TextInputAction.newline,
              ),
              16.height,
              AppTextField(
                controller: cityCont,
                focus: cityFocus,
                nextFocus: stateFocus,
                textFieldType: TextFieldType.OTHER,
                decoration: textInputStyle(context: context, label: 'City'),
              ),
              16.height,
              AppTextField(
                controller: stateCont,
                focus: stateFocus,
                nextFocus: countryFocus,
                textFieldType: TextFieldType.OTHER,
                decoration: textInputStyle(context: context, label: 'State'),
              ),
              16.height,
              AppTextField(
                controller: countryCont,
                focus: countryFocus,
                textFieldType: TextFieldType.OTHER,
                decoration: textInputStyle(context: context, label: 'Country'),
              ),
            ],
          ),
        ),
      );
    }

    addEditedData() async {
      isLoading = true;
      setState(() {});
      Map<String, dynamic> request = {
        "user_id": "${getIntAsync(USER_ID)}",
        "firstname": firstNameCont.text,
        "lastname": lastNameCont.text,
        "address": addressCont.text,
        "city": cityCont.text,
        "country": countryCont.text,
        "state": stateCont.text,
        "translated_name": getTranslatedName()
      };
      updateProfile(request, file: selectedImage != null ? File(selectedImage!.path) : null).then((value) {
      }).whenComplete(() {
        isLoading = false;
        setState(() {});
      });
      isLoading = false;
      setState(() {});
    }

    saveDetails() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        addEditedData();
      }
    }

    void getUserDetails(ProfileModel getDetail) {
      firstNameCont.text = getDetail.first_name.validate();
      lastNameCont.text = getDetail.last_name.validate();
      addressCont.text = getDetail.address.validate();
      cityCont.text = getDetail.city.validate();
      stateCont.text = getDetail.state.validate();
      countryCont.text = getDetail.country.validate();
      if (getDetail.profile_image.validate().isNotEmpty) {
        setValue(PROFILE_IMAGE, getDetail.profile_image.validate());
      }
    }

    Widget body1() {
      return FutureBuilder<ProfileModel>(
        future: getUserProfile(getIntAsync(USER_ID), getStringAsync(USER_ROLE)),
        builder: (_, snap) {
          if (snap.hasData) {
            if (isFirst) {
              getUserDetails(snap.data!);
              isFirst = false;
            }
            return body();
          }
          return snapWidgetHelper(snap, errorWidget: noDataWidget(text: errorMessage, isInternet: true));
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: appAppBar(context, name: 'Edit Profile'),
        body: body1().visible(!isLoading, defaultWidget: setLoader()),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: const Icon(Icons.done, color: textPrimaryWhiteColor),
          onPressed: () {
            hideKeyboard(context);
            saveDetails();
          },
        ),
      ),
    );
  }
}
