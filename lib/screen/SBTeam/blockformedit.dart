import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/blockform.dart';
import 'package:stoneindia/model/type.dart';
import 'package:stoneindia/screen/SBTeam/adddatadialog.dart';
import 'package:stoneindia/screen/SBTeam/editimageblockform.dart';
import 'package:stoneindia/widget/appcommon.dart';

class EditBlockFormScreen extends StatefulWidget {
  final BlockFormData? blockFormData;
  const EditBlockFormScreen({super.key, this.blockFormData});

  @override
  _EditBlockFormScreenState createState() => _EditBlockFormScreenState();
}

class _EditBlockFormScreenState extends State<EditBlockFormScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String>? blocklistdata = [];
  var blockSelected;
  List<String>? productlistdata = [];
  var productSelected;
  List<String>? categorylistdata = [];
  var categorySelected;
  List<String>? slablistdata = [];
  var slabSelected;
  List<String>? thicknesslistdata = [];
  var thicknessSelected;
  String? isEnquiry;
  List<TypeModel> typeList = [];
  List<int> selectedItems = [];
  int selectedType = -1;
  TextEditingController slength = TextEditingController();
  TextEditingController swidth = TextEditingController();
  TextEditingController sthickness = TextEditingController();
  TextEditingController stotalslab = TextEditingController();
  bool isloading = false;
  int? initialblockindex = 0;
  int? initialproductindex;
  int? initialcategoryindex;
  int? initialslabindex;
  int? intialthicknessindex;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    print(widget.blockFormData!.slab_type_name);
    setStatusBarColor(scaffoldBgColor,
        statusBarIconBrightness: Brightness.light);
    typeList.add(TypeModel(
        name: 'Enquiry', icon: FontAwesomeIcons.store, value: "enquiry"));
    typeList.add(TypeModel(
        name: 'Factory', icon: FontAwesomeIcons.question, value: "factory"));
    setState(() {
      isloading = true;
      if (widget.blockFormData!.form_type == 'factory') {
        selectedType = 1;
        isEnquiry = 'factory';
      }
      if (widget.blockFormData!.form_type == 'enquiry') {
        selectedType = 0;
        isEnquiry = 'enquiry';
      }

      blocklistdata = getStringListAsync(BLOCK_LIST);
      print("ok ${blocklistdata!.length}");
      productlistdata = getStringListAsync(PRODUCT_LIST);
      print("ok ${productlistdata!.length}");
      categorylistdata = getStringListAsync(CATEGORY_LIST);
      print("ok ${categorylistdata!.length}");
      slablistdata = getStringListAsync(SLAB_LIST);
      print("ok ${slablistdata!.length}");
      thicknesslistdata = getStringListAsync(THICKNESS_LIST);
      print("ok ${thicknesslistdata!.length}");
      if (widget.blockFormData!.block_name != null) {
        if (blocklistdata != null) {
          if (blocklistdata!.isNotEmpty) {
            print(blocklistdata);
            print(widget.blockFormData!.block_name.toString());
            if (blocklistdata!
                .contains(widget.blockFormData!.block_name.toString())) {
              blockSelected = widget.blockFormData!.block_name.toString();
              initialblockindex =
                  blocklistdata!.indexWhere((item) => item == blockSelected);
              print(initialblockindex);
            }
          }
        }
      }
      if (widget.blockFormData!.product_name != null) {
        if (productlistdata != null) {
          if (productlistdata!.isNotEmpty) {
            if (productlistdata!
                .contains(widget.blockFormData!.product_name.toString())) {
              productSelected = widget.blockFormData!.product_name.toString();
              initialproductindex = productlistdata!
                  .indexWhere((item) => item == productSelected);
              print(initialproductindex);
            }
          }
        }
      }
      if (widget.blockFormData!.category_name != null) {
        if (categorylistdata != null) {
          if (categorylistdata!.isNotEmpty) {
            if (categorylistdata!
                .contains(widget.blockFormData!.category_name.toString())) {
              categorySelected = widget.blockFormData!.category_name.toString();
              initialcategoryindex = categorylistdata!
                  .indexWhere((item) => item == categorySelected);
              print(initialcategoryindex);
            }
          }
        }
      }
      if (widget.blockFormData!.slab_type_name != null) {
        if (slablistdata != null) {
          if (slablistdata!.isNotEmpty) {
            if (slablistdata!
                .contains(widget.blockFormData!.slab_type_name.toString())) {
              slabSelected = widget.blockFormData!.slab_type_name.toString();
              initialslabindex =
                  slablistdata!.indexWhere((item) => item == slabSelected);
              print(initialslabindex);
            }
          }
        }
      }
      if (widget.blockFormData!.slab_thickness != null) {
        if (thicknesslistdata != null) {
          if (thicknesslistdata!.isNotEmpty) {
            if (thicknesslistdata!
                .contains(widget.blockFormData!.slab_thickness.toString())) {
              thicknessSelected =
                  widget.blockFormData!.slab_thickness.toString();
              intialthicknessindex = thicknesslistdata!
                  .indexWhere((item) => item == thicknessSelected);
              print(intialthicknessindex);
            }
          }
        }
      }
      slength.text = widget.blockFormData!.slab_length.toString();
      swidth.text = widget.blockFormData!.slab_height.toString();
      // sthickness.text = widget.blockFormData!.slab_thickness.toString();
      stotalslab.text = widget.blockFormData!.total_slabs.toString();
      isloading = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(
      scaffoldBgColor,
      statusBarIconBrightness: Brightness.light,
    );
    super.dispose();
  }

  void addblockdialog() {
    showInDialog(context,
        title: Text("Add Block",
            style: boldTextStyle(), textAlign: TextAlign.justify),
        barrierColor: Colors.black45,
        backgroundColor: scaffoldBgColor, builder: (context) {
      return const AddDataDailog(datatype: "block");
    });
  }

  void addproductdialog() {
    showInDialog(context,
        title: Text("Add Product",
            style: boldTextStyle(), textAlign: TextAlign.justify),
        barrierColor: Colors.black45,
        backgroundColor: scaffoldBgColor, builder: (context) {
      return const AddDataDailog(datatype: "product");
    });
  }

  void addcategorydialog() {
    showInDialog(context,
        title: Text("Add Category",
            style: boldTextStyle(), textAlign: TextAlign.justify),
        barrierColor: Colors.black45,
        backgroundColor: scaffoldBgColor, builder: (context) {
      return const AddDataDailog(datatype: "category");
    });
  }

  void addslabdialog() {
    showInDialog(context,
        title: Text("Add Slab Type",
            style: boldTextStyle(), textAlign: TextAlign.justify),
        barrierColor: Colors.black45,
        backgroundColor: scaffoldBgColor, builder: (context) {
      return const AddDataDailog(datatype: "slab");
    });
  }

  void addthicknessdialog() {
    showInDialog(context,
        title: Text("Add Thickness",
            style: boldTextStyle(), textAlign: TextAlign.justify),
        barrierColor: Colors.black45,
        backgroundColor: scaffoldBgColor, builder: (context) {
      return const AddDataDailog(datatype: "thickness");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar(context, name: 'Edit Block Form'),
        body: SingleChildScrollView(
          child: (isloading == true ||
                  thicknesslistdata!.isEmpty ||
                  blocklistdata!.isEmpty ||
                  productlistdata!.isEmpty ||
                  categorylistdata!.isEmpty ||
                  slablistdata!.isEmpty)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: kPrimaryColor,
                    ),
                  ),
                )
              : Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          24.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Fill the details below',
                                      style:
                                          boldTextStyle(size: titleTextSize)),
                                  8.height,
                                ],
                              ),
                            ],
                          ),
                          16.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Block',
                                style: primaryTextStyle(
                                    size: 14, color: kPrimaryColor),
                              ),
                              5.height,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
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
                                      initialIndex: initialblockindex,
                                      primaryColor: kPrimaryColor,
                                      menuMode: true,
                                      labelStyle: const TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                      items: blocklistdata!.toList(),
                                      label: ' Select Block',
                                      prefixIcon: const Icon(Icons.search),
                                      dropDownMenuItems:
                                          blocklistdata!.map((item) {
                                                return item;
                                              }).toList() ??
                                              [],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            blockSelected = value.toString();
                                            initialblockindex = blocklistdata!
                                                .indexWhere((item) =>
                                                    item == blockSelected);
                                          });
                                          print(blockSelected);
                                        } else {
                                          setState(() {
                                            blockSelected = null;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    color: kPrimaryColor,
                                    onPressed: () async {
                                      addblockdialog();
                                    },
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
                              Text(
                                'Product',
                                style: primaryTextStyle(
                                    size: 14, color: kPrimaryColor),
                              ),
                              5.height,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
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
                                      initialIndex: initialproductindex,
                                      menuMode: true,
                                      labelStyle: const TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                      items: productlistdata!.toList(),
                                      label: ' Select Product',
                                      prefixIcon: const Icon(Icons.search),
                                      dropDownMenuItems:
                                          productlistdata!.map((item) {
                                                return item;
                                              }).toList() ??
                                              [],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            productSelected = value.toString();
                                            initialproductindex =
                                                productlistdata!.indexWhere(
                                                    (item) =>
                                                        item ==
                                                        productSelected);
                                          });
                                        } else {
                                          setState(() {
                                            productSelected = null;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    color: kPrimaryColor,
                                    onPressed: () {
                                      addproductdialog();
                                    },
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    alignment: Alignment.centerLeft,
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
                                      initialIndex: initialcategoryindex,
                                      primaryColor: kPrimaryColor,
                                      menuMode: true,
                                      labelStyle: const TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                      items: categorylistdata!.toList(),
                                      label: ' Select Category',
                                      prefixIcon: const Icon(Icons.search),
                                      dropDownMenuItems:
                                          categorylistdata!.map((item) {
                                                return item;
                                              }).toList() ??
                                              [],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            categorySelected = value.toString();
                                            initialcategoryindex =
                                                categorylistdata!.indexWhere(
                                                    (item) =>
                                                        item ==
                                                        categorySelected);
                                          });
                                        } else {
                                          setState(() {
                                            categorySelected = null;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    color: kPrimaryColor,
                                    onPressed: () {
                                      addcategorydialog();
                                    },
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
                              Text(
                                'Type',
                                style: primaryTextStyle(
                                    size: 14, color: kPrimaryColor),
                              ),
                              5.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                  typeList.length,
                                  (index) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 16, 8, 16),
                                      decoration:
                                          boxDecorationWithRoundedCorners(
                                        borderRadius: radius(defaultRadius),
                                        backgroundColor: context.cardColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: selectedType == index
                                                ? const EdgeInsets.all(2)
                                                : const EdgeInsets.all(1),
                                            decoration:
                                                boxDecorationWithRoundedCorners(
                                              boxShape: BoxShape.circle,
                                              border: Border.all(
                                                  color: selectedType == index
                                                      ? kPrimaryColor
                                                      : secondaryTxtColor
                                                          .withOpacity(0.5)),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            child: Container(
                                              height: selectedType == index
                                                  ? 10
                                                  : 10,
                                              width: selectedType == index
                                                  ? 10
                                                  : 10,
                                              decoration:
                                                  boxDecorationWithRoundedCorners(
                                                boxShape: BoxShape.circle,
                                                backgroundColor:
                                                    selectedType == index
                                                        ? kPrimaryColor
                                                        : white,
                                              ),
                                            ),
                                          ),
                                          8.width,
                                          Text(typeList[index].name!,
                                                  style: const TextStyle(
                                                      color: secondaryTxtColor,
                                                      fontWeight:
                                                          FontWeight.bold))
                                              .flexible()
                                        ],
                                      ).center(),
                                    ).onTap(() {
                                      if (selectedType == index) {
                                        selectedType = -1;
                                      } else {
                                        setState(() {
                                          isEnquiry = typeList[index].value;
                                          selectedType = index;
                                        });
                                        print(isEnquiry);
                                      }
                                      setState(() {});
                                    },
                                        borderRadius: BorderRadius.circular(
                                            defaultRadius)).paddingRight(16);
                                  },
                                ),
                              ),
                            ],
                          ),
                          16.height,
                          Column(
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: CustomSearchableDropDown(
                                      dropdownHintText:
                                          ' Search for slab here... ',
                                      showLabelInMenu: true,
                                      dropdownItemStyle:
                                          const TextStyle(color: kPrimaryColor),
                                      primaryColor: kPrimaryColor,
                                      menuMode: true,
                                      labelStyle: const TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                      initialIndex: initialslabindex,
                                      items: slablistdata!.toList(),
                                      label: ' Select Slab',
                                      prefixIcon: const Icon(Icons.search),
                                      dropDownMenuItems:
                                          slablistdata!.map((item) {
                                                return item;
                                              }).toList() ??
                                              [],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            slabSelected = value.toString();
                                            initialslabindex = slablistdata!
                                                .indexWhere((item) =>
                                                    item == slabSelected);
                                          });
                                        } else {
                                          setState(() {
                                            slabSelected = null;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    color: kPrimaryColor,
                                    onPressed: () {
                                      addslabdialog();
                                    },
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
                              Text(
                                'Slab Size (Inch)',
                                style: primaryTextStyle(
                                    size: 14, color: kPrimaryColor),
                              ),
                              5.height,
                              Row(
                                children: [
                                  AppTextField(
                                    controller: slength,
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: textInputStyle(
                                        context: context, label: 'Length'),
                                    scrollPadding: const EdgeInsets.all(0),
                                  ).expand(),
                                  10.width,
                                  const Text("x"),
                                  10.width,
                                  AppTextField(
                                    controller: swidth,
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: textInputStyle(
                                        context: context, label: 'Width'),
                                  ).expand(),
                                ],
                              ),
                            ],
                          ),
                          16.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Slab Thickness (Cm)',
                                style: primaryTextStyle(
                                    size: 14, color: kPrimaryColor),
                              ),
                              5.height,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: CustomSearchableDropDown(
                                      dropdownHintText:
                                          ' Search for thickness here... ',
                                      showLabelInMenu: true,
                                      dropdownItemStyle:
                                          const TextStyle(color: kPrimaryColor),
                                      primaryColor: kPrimaryColor,
                                      menuMode: true,
                                      labelStyle: const TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                      initialIndex: intialthicknessindex,
                                      items: thicknesslistdata!.toList(),
                                      label: ' Select Thickness',
                                      prefixIcon: const Icon(Icons.search),
                                      dropDownMenuItems:
                                          thicknesslistdata!.map((item) {
                                                return item;
                                              }).toList() ??
                                              [],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            thicknessSelected =
                                                value.toString();
                                          });
                                        } else {
                                          setState(() {
                                            thicknessSelected = null;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    color: kPrimaryColor,
                                    onPressed: () {
                                      addthicknessdialog();
                                    },
                                  )
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     AppTextField(
                              //       controller: sthickness,
                              //       textFieldType: TextFieldType.NUMBER,
                              //       decoration: textInputStyle(context: context, label: 'Thickness'),
                              //     ).expand(),
                              //   ],
                              // ),
                            ],
                          ),
                          16.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Total Slab',
                                style: primaryTextStyle(
                                    size: 14, color: kPrimaryColor),
                              ),
                              5.height,
                              AppTextField(
                                controller: stotalslab,
                                textFieldType: TextFieldType.NUMBER,
                                decoration: textInputStyle(
                                    context: context, label: 'Total Slab'),
                                scrollPadding: const EdgeInsets.all(0),
                              ),
                            ],
                          ),
                        ],
                      ).paddingAll(16),
                      86.height,
                    ],
                  ),
                ).visible(!isLoading, defaultWidget: setLoader()),
        ),
        floatingActionButton: AddFloatingButton(
          icon: FontAwesomeIcons.arrowRight,
          onTap: () {
            print(blockSelected);
            if (blockSelected == null ||
                productSelected == null ||
                categorySelected == null ||
                isEnquiry == null ||
                slabSelected == null ||
                thicknessSelected == null) {
              toast("Empty Data");
            } else {
              EditImageBlockFormScreen(
                      block_id: widget.blockFormData!.id,
                      block_name: blockSelected.toString(),
                      product_name: productSelected.toString(),
                      category_name: categorySelected.toString(),
                      form_type: isEnquiry.toString(),
                      slab_type_name: slabSelected.toString(),
                      slab_height: swidth.text.toString(),
                      slab_length: slength.text.toString(),
                      slab_thickness: thicknessSelected.toString(),
                      total_slabs: stotalslab.text.toString(),
                      blockform_images: widget.blockFormData!.images)
                  .launch(context);
            }
          },
        ),
      ),
    );
  }
}
