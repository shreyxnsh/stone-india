import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/blockform.dart';
import 'package:stoneindia/model/type.dart';
import 'package:stoneindia/screen/SBCustomer/sbcustomerdashboard.dart';
import 'package:stoneindia/screen/SBTeam/sbteamdashboard.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:intl/intl.dart';

class CatalogueFilterDailog extends StatefulWidget {
  const CatalogueFilterDailog({super.key});

  @override
  CatalogueFilterDailogState createState() => CatalogueFilterDailogState();
}

class CatalogueFilterDailogState extends State<CatalogueFilterDailog> {
  var formKey = GlobalKey<FormState>();
  List typeListData = [
    "Factory",
    "Enquiry",
    "Testimonial",
    "Monument",
    "Tiles"
  ];
  var typeSelected;
  List<TypeModel> typeList = [];
  int selectedType = -1;
  String? isEnquiry;
  List productListData = [];
  var productSelected;
  List blockListData = [];
  var blockSelected;
  List categorylistdata = [];
  List slablistdata = [];
  var categorySelected;
  var slabSelected;
  List thicknesslistdata = [];
  var thicknessSelected;
  TextEditingController filterDateCont = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(scaffoldBgColor,
        statusBarIconBrightness: Brightness.light);
  }

  Future<void> init() async {
    typeList.add(TypeModel(
        name: 'Enquiry', icon: FontAwesomeIcons.store, value: "enquiry"));
    typeList.add(TypeModel(
        name: 'Factory', icon: FontAwesomeIcons.question, value: "factory"));
    setState(() {
      blockListData = getStringListAsync(BLOCK_LIST)!.toList();
      print("ok ${blockListData.length}");
      productListData = getStringListAsync(PRODUCT_LIST)!.toList();
      print("ok ${productListData.length}");
      categorylistdata = getStringListAsync(CATEGORY_LIST)!.toList();
      print("ok ${categorylistdata.length}");
      slablistdata = getStringListAsync(SLAB_LIST)!.toList();
      print("ok ${slablistdata.length}");
      thicknesslistdata = (getStringListAsync(THICKNESS_LIST)?.toList() ?? []);
      print("ok ${thicknesslistdata.length}");
    });
  }

  Future cataloguefilterCustomerData() async {
    print(typeSelected);
    print(productSelected);
    print(blockSelected);
    print(categorySelected);
    print(slabSelected);
    print(thicknessSelected);
    await cataloguecustomerfilter(
            user_id: getIntAsync(USER_ID),
            selectedType: typeSelected,
            selectedProduct: productSelected,
            selectedBlock: blockSelected,
            selectedCategory: categorySelected,
            selectedSlab: slabSelected,
            slab_thickness: thicknessSelected)
        .then((value) {
      if (value.status == true) {
        if (value.blockFormData != null) {
          if (value.blockFormData!.isNotEmpty) {
            setValue(FILTER_LAST_ID, value.last_id);
            setValue(
                CUSTOMER_TOTAL_BLOCK_FORM_COUNT, value.total_block_form_count);
            List<BlockFormData> blockFormData = [];
            for (var element in value.blockFormData!) {
              blockFormData.add(BlockFormData(
                id: element.id,
                block_name: element.block_name,
                product_name: element.product_name,
                category_name: element.category_name,
                form_type: element.form_type,
                slab_type_name: element.slab_type_name,
                slab_height: element.slab_height,
                slab_length: element.slab_length,
                slab_thickness: element.slab_thickness,
                total_slabs: element.total_slabs,
                form_status: element.form_status,
                images: element.images == null ? [] : element.images!.toList(),
              ));
            }
            setValue(BLOCK_FORM, jsonEncode(blockFormData));
            print("BLOCK_FORM Filter: ${getStringAsync(BLOCK_FORM)}");
            SBCustomerDashboard(
                    runHomeApi: false,
                    isfilter: true,
                    isfirst: false,
                    typeSelected: typeSelected,
                    productSelected: productSelected,
                    blockSelected: blockSelected,
                    categorySelected: categorySelected,
                    slabSelected: slabSelected,
                    thicknessSelected: thicknessSelected)
                .launch(context, isNewTask: true);
          }
        }
      } else if (value.status == false) {
        errorToast(value.message.toString());
        const SBCustomerDashboard(
                runHomeApi: false, isfilter: false, isfirst: false)
            .launch(context, isNewTask: true);
      }
    }).catchError((e) {
      errorToast(e.toString());
    });
  }

  Future cataloguefilterData() async {
    print(typeSelected);
    print(productSelected);
    print(blockSelected);
    print(categorySelected);
    print(slabSelected);
    print(thicknessSelected);
    await cataloguefilter(
            selectedType: typeSelected,
            selectedProduct: productSelected,
            selectedBlock: blockSelected,
            selectedCategory: categorySelected,
            selectedSlab: slabSelected,
            slab_thickness: thicknessSelected,
            date: filterDateCont.text)
        .then((value) {
      if (value.status == true) {
        if (value.blockFormData != null) {
          if (value.blockFormData!.isNotEmpty) {
            List<BlockFormData> blockFormData = [];
            setValue(FILTER_LIST_LAST_ID, value.last_id);
            setValue(TEAM_TOTAL_BLOCK_FORM_COUNT, value.total_block_form_count);
            for (var element in value.blockFormData!) {
              blockFormData.add(BlockFormData(
                id: element.id,
                block_name: element.block_name,
                product_name: element.product_name,
                category_name: element.category_name,
                form_type: element.form_type,
                slab_type_name: element.slab_type_name,
                slab_height: element.slab_height,
                slab_length: element.slab_length,
                slab_thickness: element.slab_thickness,
                total_slabs: element.total_slabs,
                form_status: element.form_status,
                upload_date: element.upload_date,
                images: element.images == null ? [] : element.images!.toList(),
              ));
            }
            setValue(BLOCK_FORM_LIST, jsonEncode(blockFormData));
            print("BLOCK_FORM_LIST Filter: ${getStringAsync(BLOCK_FORM_LIST)}");
            print(typeSelected);
            SBTeamDashboard(
                    runHomeApi: false,
                    isfilter: true,
                    typeSelected: typeSelected,
                    productSelected: productSelected,
                    blockSelected: blockSelected,
                    categorySelected: categorySelected,
                    slabSelected: slabSelected,
                    thicknessSelected: thicknessSelected,
                    date: filterDateCont.text)
                .launch(context, isNewTask: true);
          }
        }
      } else if (value.status == false) {
        errorToast(value.message.toString());
        const SBTeamDashboard(runHomeApi: false, isfilter: false)
            .launch(context, isNewTask: true);
      }
    }).catchError((e) {
      errorToast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: (blockListData.isEmpty ||
                thicknesslistdata.isEmpty ||
                productListData.isEmpty ||
                categorylistdata.isEmpty ||
                slablistdata.isEmpty)
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
            : Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    16.height,
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 20),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: List.generate(
                    //           typeList.length,
                    //               (index) {
                    //             return Container(
                    //               width: MediaQuery.of(context).size.width,
                    //               // alignment: Alignment.topLeft,
                    //               padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                    //               decoration: boxDecorationWithRoundedCorners(
                    //                 borderRadius: radius(defaultRadius),
                    //                 backgroundColor: context.cardColor,
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.start,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Container(
                    //                     padding: selectedType == index ? EdgeInsets.all(2) : EdgeInsets.all(1),
                    //                     decoration: boxDecorationWithRoundedCorners(
                    //                       boxShape: BoxShape.circle,
                    //                       border: Border.all(color: selectedType == index ? kPrimaryColor : secondaryTxtColor.withOpacity(0.5)),
                    //                       backgroundColor: Colors.transparent,
                    //                     ),
                    //                     child: Container(
                    //                       height: selectedType == index ? 10 : 10,
                    //                       width: selectedType == index ? 10 : 10,
                    //                       decoration: boxDecorationWithRoundedCorners(
                    //                         boxShape: BoxShape.circle,
                    //                         backgroundColor: selectedType == index ? kPrimaryColor : white,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   8.width,
                    //                   Text(typeList[index].name!, style: TextStyle(color: secondaryTxtColor, fontWeight: FontWeight.bold)).flexible()
                    //                 ],
                    //               ).center(),
                    //             ).paddingBottom(25).onTap(() {
                    //               if (selectedType == index) {
                    //                 selectedType = -1;
                    //               } else {
                    //                 setState(() {
                    //                   isEnquiry = typeList[index].value?.toLowerCase();
                    //                   selectedType = index;
                    //                 });
                    //                 print(isEnquiry);
                    //               }
                    //               setState(() {});
                    //             }, borderRadius: BorderRadius.circular(defaultRadius)).paddingRight(16);
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // if((getStringAsync(USER_MOBILE).startsWith('91') == false && getStringAsync(USER_ROLE) == 'customer') || getStringAsync(USER_ROLE) == 'team')
                    if (getStringAsync(USER_ROLE) == 'team')
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Type',
                              style: primaryTextStyle(
                                  size: 14, color: kPrimaryColor),
                            ),
                            5.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width -
                                      42, //- 130
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CustomSearchableDropDown(
                                    dropdownHintText:
                                        ' Search for type here... ',
                                    showLabelInMenu: true,
                                    dropdownItemStyle:
                                        const TextStyle(color: kPrimaryColor),
                                    primaryColor: kPrimaryColor,
                                    menuMode: true,
                                    labelStyle: const TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold),
                                    items: typeListData,
                                    label: ' Select Type',
                                    prefixIcon: const Icon(Icons.search),
                                    dropDownMenuItems: typeListData.map((item) {
                                          return item;
                                        }).toList() ??
                                        [],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          typeSelected = value.toString();
                                        });
                                      } else {
                                        setState(() {
                                          typeSelected = null;
                                        });
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'Product',
                            style: primaryTextStyle(
                                size: 14, color: kPrimaryColor),
                          ),
                        ),
                        5.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width -
                                    42, //-130
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CustomSearchableDropDown(
                                  dropdownHintText:
                                      ' Search for product here... ',
                                  showLabelInMenu: true,
                                  dropdownItemStyle:
                                      const TextStyle(color: kPrimaryColor),
                                  primaryColor: kPrimaryColor,
                                  menuMode: true,
                                  labelStyle: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                  items: productListData.toList(),
                                  label: ' Select Product',
                                  prefixIcon: const Icon(Icons.search),
                                  dropDownMenuItems:
                                      productListData.map((item) {
                                            return item;
                                            // return item.split(" ###@@@###SB###@@@### ")[0];
                                          }).toList() ??
                                          [],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        // print(value.split(" ###@@@###SB###@@@### ")[1]);
                                        // productSelected = value.split(" ###@@@###SB###@@@### ")[1];
                                        productSelected = value.toString();
                                      });
                                    } else {
                                      setState(() {
                                        productSelected = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'Block',
                            style: primaryTextStyle(
                                size: 14, color: kPrimaryColor),
                          ),
                        ),
                        5.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width -
                                    42, //- 130
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CustomSearchableDropDown(
                                  dropdownHintText:
                                      ' Search for block here... ',
                                  showLabelInMenu: true,
                                  dropdownItemStyle:
                                      const TextStyle(color: kPrimaryColor),
                                  primaryColor: kPrimaryColor,
                                  menuMode: true,
                                  labelStyle: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                  items: blockListData.toList(),
                                  label: ' Select Block',
                                  prefixIcon: const Icon(Icons.search),
                                  dropDownMenuItems: blockListData.map((item) {
                                        // return item.split(" ###@@@###SB###@@@### ")[0];
                                        return item;
                                      }).toList() ??
                                      [],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        // print(value.split(" ###@@@###SB###@@@### ")[1]);
                                        // blockSelected = value.split(" ###@@@###SB###@@@### ")[1];
                                        blockSelected = value.toString();
                                      });
                                    } else {
                                      setState(() {
                                        blockSelected = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    16.height,
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: primaryTextStyle(
                                size: 14, color: kPrimaryColor),
                          ),
                          5.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // width: MediaQuery.of(context).size.width*0.9,//0.7
                                width: MediaQuery.of(context).size.width - 42,
                                // alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CustomSearchableDropDown(
                                  dropdownHintText:
                                      ' Search for category here... ',
                                  showLabelInMenu: true,
                                  dropdownItemStyle:
                                      const TextStyle(color: kPrimaryColor),
                                  primaryColor: kPrimaryColor,
                                  menuMode: true,
                                  labelStyle: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                  items: categorylistdata.toList(),
                                  label: ' Select Category',
                                  prefixIcon: const Icon(Icons.search),
                                  dropDownMenuItems:
                                      categorylistdata.map((item) {
                                            return item;
                                          }).toList() ??
                                          [],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        categorySelected = value.toString();
                                      });
                                    } else {
                                      setState(() {
                                        categorySelected = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Slab Type',
                            style: primaryTextStyle(
                                size: 14, color: kPrimaryColor),
                          ),
                          5.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 42,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CustomSearchableDropDown(
                                  dropdownHintText: ' Search for slab here... ',
                                  showLabelInMenu: true,
                                  dropdownItemStyle:
                                      const TextStyle(color: kPrimaryColor),
                                  primaryColor: kPrimaryColor,
                                  menuMode: true,
                                  labelStyle: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                  items: slablistdata.toList(),
                                  label: ' Select Slab',
                                  prefixIcon: const Icon(Icons.search),
                                  dropDownMenuItems: slablistdata.map((item) {
                                        return item;
                                      }).toList() ??
                                      [],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        slabSelected = value.toString();
                                      });
                                    } else {
                                      setState(() {
                                        slabSelected = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Slab Thickness (In Cm)',
                            style: primaryTextStyle(
                                size: 14, color: kPrimaryColor),
                          ),
                          5.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 42,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CustomSearchableDropDown(
                                  dropdownHintText:
                                      ' Search for slab thickness here... ',
                                  showLabelInMenu: true,
                                  dropdownItemStyle:
                                      const TextStyle(color: kPrimaryColor),
                                  primaryColor: kPrimaryColor,
                                  menuMode: true,
                                  labelStyle: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                  items: thicknesslistdata.toList(),
                                  label: ' Select Slab Thickness',
                                  prefixIcon: const Icon(Icons.search),
                                  dropDownMenuItems:
                                      thicknesslistdata.map((item) {
                                            return item;
                                          }).toList() ??
                                          [],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        print(value.toString());
                                        thicknessSelected = value.toString();
                                      });
                                    } else {
                                      setState(() {
                                        thicknessSelected = null;
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (getStringAsync(USER_ROLE) == "team") 24.height,
                    if (getStringAsync(USER_ROLE) == "team")
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: primaryTextStyle(
                                    size: 14, color: kPrimaryColor),
                              ),
                              5.height,
                              AppTextField(
                                controller: filterDateCont,
                                textFieldType: TextFieldType.OTHER,
                                decoration: textInputStyle(
                                  context: context,
                                  label: 'Select Date',
                                  isMandatory: false,
                                  suffixIcon: commonImage(
                                    imageUrl: "assets/icons/calendar.png",
                                    size: 10,
                                  ),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate ?? DateTime.now(),
                                    firstDate: DateTime(2023, 01),
                                    lastDate: DateTime(2035,
                                        12), //DateTime.now().add(Duration(days: 5)),//DateTime.now().add(appStore.restrictAppointmentPost.days),
                                    helpText: "Select Date",
                                    builder: (context, child) {
                                      return child!;
                                    },
                                  );
                                  filterDateCont.text = DateFormat(CONVERT_DATE)
                                      .format(selectedDate!);
                                  print(filterDateCont.text);
                                  setState(() {});
                                },
                              ),
                            ],
                          )),
                    24.height,
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: AppButton(
                        width: context.width(),
                        shapeBorder:
                            RoundedRectangleBorder(borderRadius: radius()),
                        onTap: () async {
                          if (getStringAsync(USER_ROLE) ==
                              UserRoleStoneBharatTeam) {
                            await cataloguefilterData();
                          } else if (getStringAsync(USER_ROLE) ==
                              UserRoleCustomer) {
                            await cataloguefilterCustomerData();
                          }
                        },
                        color: kPrimaryColor,
                        padding: const EdgeInsets.all(16),
                        child: Text("Start Filter",
                            style: boldTextStyle(color: textPrimaryWhiteColor)),
                      ),
                    ),
                  ],
                )),
      ),
    );
  }
}
