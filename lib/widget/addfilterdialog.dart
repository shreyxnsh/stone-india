import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/type.dart';

class AddFilterDailog extends StatefulWidget {

  const AddFilterDailog({Key? key, this.filtermediadata}) : super(key: key);

  final Function? filtermediadata;

  @override
  AddFilterDailogState createState() => AddFilterDailogState();
}

class AddFilterDailogState extends State<AddFilterDailog> {
  var formKey = GlobalKey<FormState>();
  List<TypeModel> typeList = [];
  int selectedType = -1;
  String? isEnquiry;
  List<String>? productListData = [];
  var productSelected;
  List<String>? blockListData = [];
  var blockSelected;
  List<String>? categoryListData = [];
  var categorySelected;
  List<String>? slabListData = [];
  var slabSelected;
  // List<String>? thicknesslistdata = [];
  // var thicknessSelected;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    typeList.add(TypeModel(name: 'Enquiry', icon: FontAwesomeIcons.store, value: "enquiry"));
    typeList.add(TypeModel(name: 'Factory', icon: FontAwesomeIcons.question, value: "factory"));
    blockListData = getStringListAsync(BLOCK_LIST);
    print("ok ${blockListData!.length}");
    productListData = getStringListAsync(PRODUCT_LIST);
    print("ok ${productListData!.length}");
    categoryListData = getStringListAsync(CATEGORY_LIST);
    print("ok ${categoryListData!.length}");
    slabListData = getStringListAsync(SLAB_LIST);
    // thicknesslistdata = getStringListAsync(THICKNESS_LIST);
    // print("ok ${thicknesslistdata!.length}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: (typeList.isEmpty || productListData!.isEmpty || blockListData!.isEmpty || categoryListData!.isEmpty || slabListData!.isEmpty)
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

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      typeList.length,
                          (index) {
                        return Container(
                          width: MediaQuery.of(context).size.width - 300,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(defaultRadius),
                            backgroundColor: context.cardColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: selectedType == index ? const EdgeInsets.all(2) : const EdgeInsets.all(1),
                                decoration: boxDecorationWithRoundedCorners(
                                  boxShape: BoxShape.circle,
                                  border: Border.all(color: selectedType == index ? kPrimaryColor : secondaryTxtColor.withOpacity(0.5)),
                                  backgroundColor: Colors.transparent,
                                ),
                                child: Container(
                                  height: selectedType == index ? 10 : 10,
                                  width: selectedType == index ? 10 : 10,
                                  decoration: boxDecorationWithRoundedCorners(
                                    boxShape: BoxShape.circle,
                                    backgroundColor: selectedType == index ? kPrimaryColor : white,
                                  ),
                                ),
                              ),
                              8.width,
                              Text(typeList[index].name!, style: const TextStyle(color: secondaryTxtColor, fontWeight: FontWeight.bold)).flexible()
                            ],
                          ).center(),
                        ).onTap(() {
                          if (selectedType == index) {
                            selectedType = -1;
                          } else {
                            setState(() {
                              isEnquiry = typeList[index].value?.toLowerCase();
                              selectedType = index;
                            });
                            print(isEnquiry);
                          }
                          setState(() {});
                        }, borderRadius: BorderRadius.circular(defaultRadius)).paddingRight(16);
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
                  Text('Block',
                    style: primaryTextStyle(size: 14, color: kPrimaryColor),
                  ),
                  5.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 130,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CustomSearchableDropDown(
                          dropdownHintText: ' Search for block here... ',
                          showLabelInMenu: true,
                          dropdownItemStyle: const TextStyle(
                              color: kPrimaryColor
                          ),
                          primaryColor: kPrimaryColor,
                          menuMode: true,
                          labelStyle: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold
                          ),
                          items: blockListData!.toList(),
                          label: ' Select Block',
                          prefixIcon:  const Icon(Icons.search),
                          dropDownMenuItems: blockListData!.map((item) {
                            return item;
                          }).toList() ??
                              [],
                          onChanged: (value){
                            if(value!=null)
                            {
                              setState(() {
                                blockSelected = value.toString();
                              });
                            }
                            else{
                              setState(() {
                                blockSelected = null;
                              });
                            }
                          },
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
                  Text('Product',
                    style: primaryTextStyle(size: 14, color: kPrimaryColor),
                  ),
                  5.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 130,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CustomSearchableDropDown(
                          dropdownHintText: ' Search for product here... ',
                          showLabelInMenu: true,
                          dropdownItemStyle: const TextStyle(
                              color: kPrimaryColor
                          ),
                          primaryColor: kPrimaryColor,
                          menuMode: true,
                          labelStyle: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold
                          ),
                          items: productListData!.toList(),
                          label: ' Select Product',
                          prefixIcon:  const Icon(Icons.search),
                          dropDownMenuItems: productListData!.map((item) {
                            return item.toString();
                          }).toList() ??
                              [],
                          onChanged: (value){
                            if(value!=null)
                            {
                              setState(() {
                                print(value.toString());
                                productSelected = value.toString();
                              });
                            }
                            else{
                              setState(() {
                                productSelected = null;
                              });
                            }
                          },
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
                  Text('Category',
                    style: primaryTextStyle(size: 14, color: kPrimaryColor),
                  ),
                  5.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 130,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CustomSearchableDropDown(
                          dropdownHintText: ' Search for category here... ',
                          showLabelInMenu: true,
                          dropdownItemStyle: const TextStyle(
                              color: kPrimaryColor
                          ),
                          primaryColor: kPrimaryColor,
                          menuMode: true,
                          labelStyle: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold
                          ),
                          items: categoryListData!.toList(),
                          label: ' Select Category',
                          prefixIcon:  const Icon(Icons.search),
                          dropDownMenuItems: categoryListData!.map((item) {
                            return item.toString();
                          }).toList() ??
                              [],
                          onChanged: (value){
                            if(value!=null)
                            {
                              setState(() {
                                print(value);
                                categorySelected = value.toString();
                              });
                            }
                            else{
                              setState(() {
                                categorySelected = null;
                              });
                            }
                          },
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
                  Text('Slab',
                    style: primaryTextStyle(size: 14, color: kPrimaryColor),
                  ),
                  5.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 130,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CustomSearchableDropDown(
                          dropdownHintText: ' Search for slab here... ',
                          showLabelInMenu: true,
                          dropdownItemStyle: const TextStyle(
                              color: kPrimaryColor
                          ),
                          primaryColor: kPrimaryColor,
                          menuMode: true,
                          labelStyle: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold
                          ),
                          items: slabListData!.toList(),
                          label: ' Select Slab',
                          prefixIcon:  const Icon(Icons.search),
                          dropDownMenuItems: slabListData!.map((item) {
                            return item;
                          }).toList() ??
                              [],
                          onChanged: (value){
                            if(value!=null)
                            {
                              setState(() {
                                print(value.toString());
                                slabSelected = value.toString();
                              });
                            }
                            else{
                              setState(() {
                                slabSelected = null;
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
              // 16.height,
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text('Slab Thickness (In Cm)',
              //       style: primaryTextStyle(size: 14, color: kPrimaryColor),
              //     ),
              //     5.height,
              //     Row(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Container(
              //           width: MediaQuery.of(context).size.width - 130,
              //           alignment: Alignment.centerLeft,
              //           decoration: BoxDecoration(
              //             color: Theme.of(context).cardColor,
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //           child: CustomSearchableDropDown(
              //             dropdownHintText: ' Search for slab thickness here... ',
              //             showLabelInMenu: true,
              //             dropdownItemStyle: TextStyle(
              //                 color: kPrimaryColor
              //             ),
              //             primaryColor: kPrimaryColor,
              //             menuMode: true,
              //             labelStyle: TextStyle(
              //                 color: kPrimaryColor,
              //                 fontWeight: FontWeight.bold
              //             ),
              //             items: thicknesslistdata!.toList(),
              //             label: ' Select Slab Thickness',
              //             prefixIcon:  Icon(Icons.search),
              //             dropDownMenuItems: thicknesslistdata!.map((item) {
              //               return item;
              //             }).toList() ??
              //                 [],
              //             onChanged: (value){
              //               if(value!=null)
              //               {
              //                 setState(() {
              //                   print(value.toString());
              //                   thicknessSelected = value.toString();
              //                 });
              //               }
              //               else{
              //                 setState(() {
              //                   thicknessSelected = null;
              //                 });
              //               }
              //             },
              //           ),
              //         )
              //       ],
              //     ),
              //   ],
              // ),
              24.height,
              AppButton(
                width: context.width(),
                shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                onTap: () async{
                  await widget.filtermediadata!(categorySelected, isEnquiry, productSelected, blockSelected, slabSelected);
                },
                color: kPrimaryColor,
                padding: const EdgeInsets.all(16),
                child: Text("Start Filter", style: boldTextStyle(color: textPrimaryWhiteColor)),
              ),
            ],
          )
      ),
    );
  }
}
