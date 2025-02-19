
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/thickness.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';

class ThicknessScreen extends StatefulWidget {
  const ThicknessScreen({super.key});


  @override
  _ThicknessScreenState createState() => _ThicknessScreenState();
}

class _ThicknessScreenState extends State<ThicknessScreen> {
  bool isLoading = false;
  bool isAddLoading = false;
  List<ThicknessData>? thickesslist = [];
  List<ThicknessData>? originalthickesslist = [];
  TextEditingController txtQuery = TextEditingController();
  var formKey = GlobalKey<FormState>();
  TextEditingController nameCont = TextEditingController();
  FocusNode nameFocus = FocusNode();
  var formKeyEdit = GlobalKey<FormState>();
  TextEditingController nameUpdateCont = TextEditingController();
  FocusNode nameUpdateFocus = FocusNode();
  bool isLoadingUpdate = false;


  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(scaffoldBgColor, statusBarIconBrightness: Brightness.light);
    await fetchthicknesslist().then((value) {
      setState(() {
        isLoading = true;
      });
      if(value.status == true){
        if(value.thicknessData != null){
          if(value.thicknessData!.isNotEmpty){
            List<ThicknessData> list = [];
            for (var element in value.thicknessData!) {
              list.add(ThicknessData(
                thickness_name: element.thickness_name,
                thickness_id: element.thickness_id,
              ));
            }
            setState(() {
              thickesslist = list;//..sort((a, b) => a.block_name!.toLowerCase().compareTo(b.block_name!.toLowerCase()));
              originalthickesslist = list;//..sort((a, b) => a.block_name!.toLowerCase().compareTo(b.block_name!.toLowerCase()));
            });
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      log(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void search(String query) {
    if (query.isEmpty) {
      thickesslist = originalthickesslist;
      setState(() {});
      return;
    }
    query = query.toLowerCase();
    print(query);
    List<ThicknessData> result = [];
    for (var p in thickesslist!) {
      var name = p.thickness_name.toString().toLowerCase();
      if (name.contains(query)) {
        result.add(ThicknessData(
            thickness_name: p.thickness_name,
            thickness_id: p.thickness_id
        ));
      }
    }
    thickesslist = result;
    setState(() {});
  }

  Widget body(){
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: txtQuery,
                  onChanged: search,
                  decoration: InputDecoration(
                    hintText: "Search here..",
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
                    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    prefixIcon: const Icon(Icons.search, color: kPrimaryColor,),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      color: kPrimaryColor,
                      onPressed: () {
                        txtQuery.text = '';
                        search(txtQuery.text);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          _listView()
        ]
    );
  }

  Widget editThickessWidget(thickenssId){
    return SingleChildScrollView(
      child: Form(
          key: formKeyEdit,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                onChanged: (value) {},
                controller: nameUpdateCont,
                textFieldType: TextFieldType.OTHER,
                decoration: textInputStyle(
                  context: context,
                  label: 'Update Here',
                  suffixIcon: commonImage(imageUrl: "assets/icons/edit.png", size: 18),
                ),
              ),
              16.height,
              Container(
                  child: (isLoadingUpdate)
                      ? AppButton(
                    width: MediaQuery.of(context).size.width,
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
                    width: MediaQuery.of(context).size.width,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                    onTap: () async{
                      setState(() {
                        isLoadingUpdate = true;
                      });
                      finish(context);
                      await editthickness(
                          thickness_id: thickenssId, name: nameUpdateCont.text).then((value) async {
                        if(value["status"] == true) {
                          await fetchthicknessdata();
                        }
                        toast(value["messages"].toString());
                        setState(() {
                          isLoadingUpdate = false;
                        });
                      }).catchError((e) {
                        log(e.toString());
                        setState(() {
                          isLoadingUpdate = false;
                        });
                      });
                      setState(() {
                        isLoadingUpdate = false;
                      });
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

  Widget _listView() {
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.only(top: 0, bottom: 0, right: 16, left: 16),
          itemCount: thickesslist!.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return ListView(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                Card(
                  color: Colors.white,
                  shadowColor: Colors.blueGrey,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(thickesslist![index].thickness_name.toString(),
                            style: const TextStyle(color: kPrimaryColor,
                              fontSize: 16,
                              fontFamily: 'Roboto',),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            iconSize: 20,
                            color: kPrimaryColor,
                            onPressed: () async{
                              setState(() {
                                nameUpdateCont.text = thickesslist![index].thickness_name.toString();
                              });
                              await showInDialog(context, title: Text("Update Thickness", style: boldTextStyle(), textAlign: TextAlign.justify), barrierColor: Colors.black45, backgroundColor: scaffoldBgColor,
                                  builder: (context) {
                                    return editThickessWidget(thickesslist![index].thickness_id);
                                  });
                            },
                          ),
                        ),
                        10.width,
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            iconSize: 20,
                            color: kPrimaryColor,
                            onPressed: () async{
                              showConfirmDialogCustom(
                                context,
                                primaryColor: primaryColor,
                                negativeText: 'No',
                                positiveText: 'Yes',
                                onAccept: (c) async {
                                  await deletethickness(
                                      thickness_id: thickesslist![index].thickness_id).then((value) async {
                                    if(value["status"] == true) {
                                      await fetchthicknessdata();
                                    }
                                    toast(value["messages"].toString());
                                  }).catchError((e) {
                                    setState(() {});
                                    log(e.toString());
                                  });
                                },
                                title: 'Are You Sure To Delete' '?',
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                8.height
              ],
            );
          }
      ),
    );
  }

  Widget AddDataDailogWidget(BuildContext context) {
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
                  child: (isAddLoading)
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
            List<ThicknessData> listdata = [];
            for (var element in value.thicknessData!) {
              listdata.add(ThicknessData(
                thickness_name: element.thickness_name,
                thickness_id: element.thickness_id,
              ));
            }
            setState(() {
              thickesslist = listdata;//..sort((a, b) => a.block_name!.toLowerCase().compareTo(b.block_name!.toLowerCase()));
              originalthickesslist = listdata;//..sort((a, b) => a.block_name!.toLowerCase().compareTo(b.block_name!.toLowerCase()));
            });
          }
        }
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  Future<void> addData() async {
    if (nameCont.text == ''){
      toast("Empty Data");
      finish(context);
    } else{
      setState(() {
        isAddLoading = true;
      });
      hideKeyboard(context);
      Map req = {
        'name': nameCont.text
      };
      addthickness(req).then((value) async {
        toast(value["messages"].toString());
        if(value["status"] == true){
          await fetchthicknessdata();
        }
        setState(() {
          isLoading = false;
        });
        finish(context);
      }).catchError((e) {
        toast(e.toString());
        setState(() {
          isLoading = false;
        });
        finish(context);
      });
      setState(() {
        isAddLoading = false;
      });
    }
  }

  void addThicknessdialog() {
    nameCont.text = '';
    showInDialog(context, title: Text(
        "Add Thickness", style: boldTextStyle(), textAlign: TextAlign.justify),
        barrierColor: Colors.black45,
        backgroundColor: scaffoldBgColor,
        builder: (context) {
          return AddDataDailogWidget(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar(context, name: 'Thickness List (In Cm)'),
        floatingActionButton: AddFloatingButton(
          onTap: () async {
            addThicknessdialog();
          },
        ),
        body: isLoading == true || isLoadingUpdate == true
            ?  const Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: kPrimaryColor,
                strokeWidth: 2,
              ),
            )
        )
            : body(),
      ),
    );
  }
}