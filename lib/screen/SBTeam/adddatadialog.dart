import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/screen/SBTeam/blockformadd.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';

class AddDataDailog extends StatefulWidget {

  const AddDataDailog({Key? key, this.datatype}) : super(key: key);

  final String? datatype;

  @override
  AddDataDailogState createState() => AddDataDailogState();
}

class AddDataDailogState extends State<AddDataDailog> {
  var formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  FocusNode nameFocus = FocusNode();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  fetchblockdata() async {
    await fetchblock().then((value) {
      if(value.status == true){
        if(value.blockData != null){
          if(value.blockData!.isNotEmpty){
            List<String> list = [];
            for (var element in value.blockData!) {
              list.add(element.block_name.toString());
            }
            setValue(BLOCK_LIST, list);
            print("BLOCK LIST: ${getStringListAsync(BLOCK_LIST)}");
          }
        }
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  fetchproductdata() async {
    await fetchproduct().then((value) {
      if(value.status == true){
        if(value.productData != null){
          if(value.productData!.isNotEmpty){
            List<String> list = [];
            for (var element in value.productData!) {
              list.add(element.product_name.toString());
            }
            setValue(PRODUCT_LIST, list);
            print("PRODUCT LIST: ${getStringListAsync(PRODUCT_LIST)}");
          }
        }
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  fetchcategorydata() async {
    await fetchcategory().then((value) {
      if(value.status == true){
        if(value.categoryData != null){
          if(value.categoryData!.isNotEmpty){
            List<String> list = [];
            for (var element in value.categoryData!) {
              list.add(element.category_name.toString());
            }
            setValue(CATEGORY_LIST, list);
            print("CATEGORY LIST: ${getStringListAsync(CATEGORY_LIST)}");
          }
        }
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  fetchslabdata() async {
    await fetchslab().then((value) {
      if(value.status == true){
        if(value.slabData != null){
          if(value.slabData!.isNotEmpty){
            List<String> list = [];
            for (var element in value.slabData!) {
              list.add(element.slab_name.toString());
            }
            setValue(SLAB_LIST, list);
            print("SLAB LIST: ${getStringListAsync(SLAB_LIST)}");
          }
        }
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  fetchthicknessdata() async {
    await fetchthicknesslist().then((value) {
      if(value.status == true){
        if(value.thicknessData != null){
          if(value.thicknessData!.isNotEmpty){
            List<String> list = [];
            for (var element in value.thicknessData!) {
              list.add(element.thickness_name.toString());
            }
            setValue(THICKNESS_LIST, list);
            print("THICKNESS LIST: ${getStringListAsync(THICKNESS_LIST)}");
          }
        }
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  Future<void> addData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if(widget.datatype == "block"){
        setState(() {
          isLoading = true;
        });
        hideKeyboard(context);
        Map req = {
          'name': nameCont.text
        };
        addblock(req).then((value) async {
          toast(value["messages"].toString());
          if(value["status"] == true){
            await fetchblockdata();
          }
          setState(() {
            isLoading = false;
          });
          finish(context);
          const AddBlockFormScreen().launch(context);
        }).catchError((e) {
          toast(e.toString());
          setState(() {
            isLoading = false;
          });
          finish(context);
        });
      }
      else if(widget.datatype == "product"){
        setState(() {
          isLoading = true;
        });
        hideKeyboard(context);
        Map req = {
          'name': nameCont.text
        };
        addproduct(req).then((value) async {
          if(value["status"] == true){
            await fetchproductdata();
          }
          toast(value["messages"].toString());
          setState(() {
            isLoading = false;
          });
          finish(context);
          const AddBlockFormScreen().launch(context);
        }).catchError((e) {
          toast(e.toString());
          setState(() {
            isLoading = false;
          });
          finish(context);
        });
      }
      else if(widget.datatype == "category"){
        setState(() {
          isLoading = true;
        });
        hideKeyboard(context);
        Map req = {
          'name': nameCont.text
        };
        addcategory(req).then((value) async {
          if(value["status"] == true){
            await fetchcategorydata();
          }
          toast(value["messages"].toString());
          setState(() {
            isLoading = false;
          });
          finish(context);
          const AddBlockFormScreen().launch(context);
        }).catchError((e) {
          toast(e.toString());
          setState(() {
            isLoading = false;
          });
          finish(context);
        });
      }
      else if(widget.datatype == "slab"){
        setState(() {
          isLoading = true;
        });
        hideKeyboard(context);
        Map req = {
          'name': nameCont.text
        };
        addslab(req).then((value) async {
          if(value["status"] == true){
            await fetchslabdata();
          }
          toast(value["messages"].toString());
          setState(() {
            isLoading = false;
          });
          finish(context);
          const AddBlockFormScreen().launch(context);
        }).catchError((e) {
          toast(e.toString());
          setState(() {
            isLoading = false;
          });
          finish(context);
        });
      }
      else if(widget.datatype == "thickness"){
        setState(() {
          isLoading = true;
        });
        hideKeyboard(context);
        Map req = {
          'name': nameCont.text
        };
        addthickness(req).then((value) async {
          if(value["status"] == true){
            await fetchthicknessdata();
          }
          toast(value["messages"].toString());
          setState(() {
            isLoading = false;
          });
          finish(context);
          const AddBlockFormScreen().launch(context);
        }).catchError((e) {
          toast(e.toString());
          setState(() {
            isLoading = false;
          });
          finish(context);
        });
      }
      else{}
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                onChanged: (value) {},
                controller: nameCont,
                textFieldType: TextFieldType.OTHER,
                decoration: textInputStyle(
                  context: context,
                  label: 'Enter Name',
                  suffixIcon: commonImage(imageUrl: "assets/icons/edit.png", size: 18),
                ),
              ),
              16.height,
              Container(
                  child: (isLoading)
                      ? AppButton(
                        width: context.width(),
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                        onTap: () {
                        },
                        color: kPrimaryColor,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Submit ', style: primaryTextStyle(color: Colors.white)),
                            const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          ],
                    ),
                  )
                      : AppButton(
                        width: context.width(),
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                        onTap: () async{
                          await addData();
                        },
                        color: kPrimaryColor,
                        padding: const EdgeInsets.all(16),
                        child: Text("Submit ", style: boldTextStyle(color: textPrimaryWhiteColor)),
                  )
              ),

            ],
          )
      ),
    );
  }
}
