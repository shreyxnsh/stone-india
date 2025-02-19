import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/blockform.dart';
import 'package:stoneindia/screen/SBCustomer/sbcustomerblockformlist.dart';
import 'package:stoneindia/screen/SBCustomer/sbcustomerdashboard.dart';
import 'package:stoneindia/screen/SBCustomer/sbcustomerholdblock.dart';
import 'package:stoneindia/screen/signin.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:stoneindia/widget/nodatafound.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class SBCustomerBlockScreen extends StatefulWidget {
  final bool? runHomeApi;
  final bool? isfilter;
  final bool? isfirst;
  final String? typeSelected;
  final String? productSelected;
  final String? blockSelected;
  final String? categorySelected;
  final String? slabSelected;
  final String? thicknessSelected;
  const SBCustomerBlockScreen(
      {super.key,
      this.runHomeApi,
      this.isfilter,
      this.typeSelected,
      this.productSelected,
      this.blockSelected,
      this.categorySelected,
      this.slabSelected,
      this.thicknessSelected,
      this.isfirst});

  @override
  _SBCustomerBlockScreenState createState() => _SBCustomerBlockScreenState();
}

class _SBCustomerBlockScreenState extends State<SBCustomerBlockScreen> {
  TextEditingController searchCont = TextEditingController();
  bool isloadingblock = false;
  bool isloadingproduct = false;
  bool isloadingcategory = false;
  bool isloadingslabs = false;
  bool isloadingserverproduct = false;
  bool isloadingserverblock = false;
  bool isloadingblocklist = false;
  List<BlockFormData>? blockformlist;
  List<BlockFormData>? originalblockformlist;
  TextEditingController txtQuery = TextEditingController();
  bool isloading = false;
  bool filter = false;
  bool isfirst = false;
  List<String> blockStatus = [];
  int selectIndex = -1;
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      isloading = true;
    });
    blockStatus.add("All Block");
    blockStatus.add("My Hold Block");
    selectIndex = 0;
    filter = widget.isfilter == null ? false : widget.isfilter!;
    isfirst = widget.isfirst == null ? false : widget.isfirst!;
    await checkIfAccountDelte();
    if (widget.runHomeApi == true) {
      await fetchblockdata();
      await fetchproductdata();
      await fetchcategorydata();
      await fetchslabdata();
      await fetchblocklistdata();
    } else {
      final data = getStringAsync(BLOCK_FORM);
      print("iamhhhn");
      if (!data.isEmptyOrNull) {
        setState(() {
          blockformlist = jsonDecode(data)
              .map((item) => BlockFormData.fromJson(item))
              .toList()
              .cast<BlockFormData>();
          originalblockformlist = blockformlist;
        });
        print(blockformlist!.first.product_name);
        if (blockformlist == null) {
          print("null");
        }
      }
    }
    setState(() {
      isloading = false;
    });
    if (isfirst) {
      await _fetchContacts();
    }
  }

  getTranslatedName(String? name) async {
    String translatedText = '';
    if (name == null) {
      return translatedText;
    } else {
      Translation translation = await translator.translate(name);
      print(translation.sourceLanguage.code);
      if (translation.sourceLanguage.code == 'en') {
        return name;
      }
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

  checkIfAccountDelte() async {
    accountDeleteStatus(getIntAsync(USER_ID)).then((value) {
      if (value["status"] == false) {
        setValue(IS_LOGGED_IN, false);
        const SignInScreen(
          isfirst: false,
        ).launch(context,
            isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      }
    });
  }

  fetchblockdata() async {
    setState(() {
      isloadingblock = true;
    });
    await fetchblock().then((value) {
      if (value.status == true) {
        if (value.blockData != null) {
          if (value.blockData!.isNotEmpty) {
            List<String> list = [];
            for (var element in value.blockData!) {
              list.add(element.block_name.toString());
            }
            setValue(BLOCK_LIST, list);
            print("BLOCK_LIST:${getStringListAsync(BLOCK_LIST)}");
          }
        }
      }
      setState(() {
        isloadingblock = false;
      });
    }).catchError((e) {
      setState(() {
        isloadingblock = false;
      });
      log(e.toString());
    });
  }

  fetchproductdata() async {
    setState(() {
      isloadingproduct = true;
    });
    await fetchproduct().then((value) {
      if (value.status == true) {
        if (value.productData != null) {
          if (value.productData!.isNotEmpty) {
            List<String> list = [];
            for (var element in value.productData!) {
              list.add(element.product_name.toString());
            }
            setValue(PRODUCT_LIST, list);
            print("PRODUCT LIST: ${getStringListAsync(PRODUCT_LIST)}");
          }
        }
      }
      setState(() {
        isloadingproduct = false;
      });
    }).catchError((e) {
      setState(() {
        isloadingproduct = false;
      });
      log(e.toString());
    });
  }

  fetchcategorydata() async {
    setState(() {
      isloadingcategory = true;
    });
    await fetchcategory().then((value) {
      if (value.status == true) {
        if (value.categoryData != null) {
          if (value.categoryData!.isNotEmpty) {
            List<String> list = [];
            for (var element in value.categoryData!) {
              list.add(element.category_name.toString());
            }
            setValue(CATEGORY_LIST, list);
            print("CATEGORY LIST: ${getStringListAsync(CATEGORY_LIST)}");
          }
        }
      }
      setState(() {
        isloadingcategory = false;
      });
    }).catchError((e) {
      setState(() {
        isloadingcategory = false;
      });
      log(e.toString());
    });
  }

  fetchslabdata() async {
    setState(() {
      isloadingslabs = true;
    });
    await fetchslab().then((value) {
      if (value.status == true) {
        if (value.slabData != null) {
          if (value.slabData!.isNotEmpty) {
            List<String> list = [];
            for (var element in value.slabData!) {
              list.add(element.slab_name.toString());
            }
            setValue(SLAB_LIST, list);
            print("SLAB LIST: ${getStringListAsync(SLAB_LIST)}");
          }
        }
      }
      setState(() {
        isloadingslabs = false;
      });
    }).catchError((e) {
      setState(() {
        isloadingslabs = false;
      });
      log(e.toString());
    });
  }

  fetchblocklistdata() async {
    setState(() {
      isloadingblocklist = true;
    });
    fetchcustomerblockform(last_id: null, customer_id: getIntAsync(USER_ID))
        .then((value) {
      if (value.status == true) {
        if (value.blockFormData != null) {
          if (value.blockFormData!.isNotEmpty) {
            List<BlockFormData> blockFormData = [];
            setValue(BLOCK_FORM_LAST_ID, value.last_id);
            setValue(
                CUSTOMER_TOTAL_BLOCK_FORM_COUNT, value.total_block_form_count);
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
            print("BLOCK_FORM: ${getStringAsync(BLOCK_FORM)}");
            final data = getStringAsync(BLOCK_FORM);
            print("fdrfrfd");
            if (!data.isEmptyOrNull) {
              print("iamherr");
              setState(() {
                blockformlist = jsonDecode(data)
                    .map((item) => BlockFormData.fromJson(item))
                    .toList()
                    .cast<BlockFormData>();
                filter = false;
                originalblockformlist = blockformlist;
              });
              print(blockformlist!.first.slab_type_name);
              if (blockformlist == null) {
                print("null");
              }
            }
          }
        }
      }
      setState(() {
        isloadingblocklist = false;
      });
    }).catchError((e) {
      print(e.toString());
      setState(() {
        isloadingblocklist = false;
      });
    });
  }

  fetchblocklistdataremovefilter() async {
    setState(() {
      isloadingblocklist = true;
    });
    fetchcustomerblockform(last_id: null, customer_id: getIntAsync(USER_ID))
        .then((value) {
      if (value.status == true) {
        if (value.blockFormData != null) {
          if (value.blockFormData!.isNotEmpty) {
            List<BlockFormData> blockFormData = [];
            setValue(BLOCK_FORM_LAST_ID, value.last_id);
            setValue(
                CUSTOMER_TOTAL_BLOCK_FORM_COUNT, value.total_block_form_count);
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
            print("BLOCK_FORM FILTER REMOVE: ${getStringAsync(BLOCK_FORM)}");
            const SBCustomerDashboard(
                    runHomeApi: false, isfilter: false, isfirst: false)
                .launch(context, isNewTask: true);
          }
        }
      }
      setState(() {
        isloadingblocklist = false;
      });
    }).catchError((e) {
      print(e.toString());
      setState(() {
        isloadingblocklist = false;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void search(String query) {
    if (query.isEmpty) {
      blockformlist = originalblockformlist;
      setState(() {});
      return;
    }
    query = query.toLowerCase();
    print(query);
    List<BlockFormData> result = [];
    for (var element in blockformlist!) {
      var name = element.product_name.toString().toLowerCase();
      if (name.contains(query)) {
        result.add(BlockFormData(
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
    }
    blockformlist = result;
    setState(() {});
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filter == true && selectIndex == 0)
          Container(
            width: MediaQuery.of(context).size.width,
            // height: 100,
            padding: const EdgeInsets.all(1),
            child: Wrap(
              children: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(kPrimaryColor),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: kPrimaryColor)))),
                  onPressed: (() async {
                    await fetchblocklistdataremovefilter();
                  }),
                  child: const Text("Remove Filter",
                      style: TextStyle(fontSize: 16)),
                ).paddingOnly(left: 1, right: 1, bottom: 2),
                if (widget.typeSelected != null)
                  TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.green.shade100),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(kPrimaryColor),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: kPrimaryColor)))),
                          onPressed: () {},
                          child: Text(widget.typeSelected.toString(),
                              style: const TextStyle(fontSize: 16)))
                      .paddingOnly(left: 1, right: 1, bottom: 2),
                if (widget.productSelected != null)
                  TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.green.shade100),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(kPrimaryColor),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: kPrimaryColor)))),
                          onPressed: () {},
                          child: Text(widget.productSelected.toString(),
                              style: const TextStyle(fontSize: 16)))
                      .paddingOnly(left: 1, right: 1, bottom: 2),
                if (widget.blockSelected != null)
                  TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.green.shade100),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(kPrimaryColor),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: kPrimaryColor)))),
                          onPressed: () {},
                          child: Text(widget.blockSelected.toString(),
                              style: const TextStyle(fontSize: 16)))
                      .paddingOnly(left: 1, right: 1, bottom: 2),
                if (widget.categorySelected != null)
                  TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.green.shade100),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(kPrimaryColor),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: kPrimaryColor)))),
                          onPressed: () {},
                          child: Text(widget.categorySelected.toString(),
                              style: const TextStyle(fontSize: 16)))
                      .paddingOnly(left: 1, right: 1, bottom: 2),
                if (widget.slabSelected != null)
                  TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.green.shade100),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(kPrimaryColor),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: kPrimaryColor)))),
                          onPressed: () {},
                          child: Text(widget.slabSelected.toString(),
                              style: const TextStyle(fontSize: 16)))
                      .paddingOnly(left: 1, right: 1, bottom: 2),
                if (widget.thicknessSelected != null)
                  TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.green.shade100),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(kPrimaryColor),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: kPrimaryColor)))),
                          onPressed: () {},
                          child: Text(
                              "${widget.thicknessSelected.toString()} Cm",
                              style: const TextStyle(fontSize: 16)))
                      .paddingOnly(left: 1, right: 1, bottom: 2),
              ],
            ),
          ),
        if (filter == true && selectIndex == 0) 8.height,
        HorizontalList(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: blockStatus.length,
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.topLeft,
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
              margin:
                  const EdgeInsets.only(left: 0, right: 8, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: selectIndex == index ? kPrimaryColor : scaffoldBgColor,
                borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
              ),
              child: FittedBox(
                child: Text(
                  blockStatus[index],
                  style: primaryTextStyle(
                      size: 14,
                      color: selectIndex == index
                          ? white
                          : Theme.of(context).iconTheme.color),
                  textAlign: TextAlign.center,
                ).paddingSymmetric(horizontal: 25, vertical: 2),
              ),
            ).onTap(
              () {
                setState(() {
                  selectIndex = index;
                });
              },
            );
          },
        ),
        8.height,
        if (selectIndex == 0)
          Text(
            'Total Blocks'
            ' (${getIntAsync(CUSTOMER_TOTAL_BLOCK_FORM_COUNT)})', //' (${blockformlist!.length})',
            style: boldTextStyle(size: titleTextSize),
          ),
        if (selectIndex == 0)
          Container(
            // margin: EdgeInsets.all(10),
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
                    prefixIcon: const Icon(
                      Icons.search,
                      color: kPrimaryColor,
                    ),
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
        if (selectIndex == 0) 8.height,
        if (selectIndex == 0)
          Container(
            child: blockformlist == null ||
                    blockformlist!.isEmpty ||
                    isloadingblock == true ||
                    isloading == true ||
                    isloadingblocklist == true ||
                    isloadingcategory == true ||
                    isloadingslabs == true ||
                    isloadingproduct == true ||
                    isloadingserverproduct == true ||
                    isloadingserverblock == true
                ? const Center(
                    child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                      strokeWidth: 2,
                    ),
                  )).expand()
                : Expanded(
                    child: CustomerBlockFormListWidget(
                            blockFormData: blockformlist)
                        .visible(
                    blockformlist != null,
                    defaultWidget:
                        const NoDataFoundWidget(iconSize: 120).center(),
                  )),
          ),
        if (selectIndex == 1) const Expanded(child: CustomerHoldScreen())
      ],
    );
  }

  Future<void> launchWhatsAppChat(String number) async {
    // await WhatsappShare.share(
    //   text: 'Hi, I would like to know more about specific Marble live on Stone India Application',
    //   phone: '+917665588871',
    // );
    final link = WhatsAppUnilink(
      phoneNumber: number.toString(),
      text:
          "Hey! I'm inquiring about the Marble listing live in Stone India Application.",
    );
    print(link);
    await launchUrlString('$link',
        mode: LaunchMode.externalNonBrowserApplication);
  }

  Future<void> sendInquiry() async {
    await sendenquiry(
            customer_id: getIntAsync(USER_ID),
            usernumber: getStringAsync(USER_MOBILE))
        .then((value) {
      if (value["status"] == true) {
        toast(value["messages"].toString());
        launchWhatsAppChat(value["number"].toString());
      }
    });
  }

  Future _reload() async {
    setState(() {
      isloadingblocklist = true;
    });
    if (filter == true) {
      print('hi filter');
      await cataloguefilter(
              selectedType: widget.typeSelected,
              selectedProduct: widget.productSelected,
              selectedBlock: widget.blockSelected,
              selectedCategory: widget.categorySelected,
              selectedSlab: widget.slabSelected,
              last_id: getIntAsync(FILTER_LAST_ID))
          .then((value) {
        if (value.status == true) {
          if (value.blockFormData != null) {
            if (value.blockFormData!.isNotEmpty) {
              List<BlockFormData>? blockformreloadlist;
              setValue(FILTER_LAST_ID, value.last_id);
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
                  images:
                      element.images == null ? [] : element.images!.toList(),
                ));
              }
              blockFormData = (blockFormData ?? []) + (blockformlist ?? []);
              setValue(BLOCK_FORM, jsonEncode(blockFormData));
              print(
                  "BLOCK_FORM Filter reload customer: ${getStringAsync(BLOCK_FORM)}");
              final data = getStringAsync(BLOCK_FORM);
              if (!data.isEmptyOrNull) {
                print("here");
                blockformreloadlist = jsonDecode(data)
                    .map((item) => BlockFormData.fromJson(item))
                    .toList()
                    .cast<BlockFormData>();
                if (blockformreloadlist != null) {
                  if (blockformreloadlist.isNotEmpty) {
                    print("previous filter customer list");
                    print(blockformlist!.length);
                    setState(() {
                      blockformlist = blockformreloadlist;
                      originalblockformlist = blockformlist;
                      //(blockformreloadlist ?? []) + (blockformlist ?? []);
                    });
                    print("updated filter customer list");
                    print(blockformlist!.length);
                  }
                }
              }
            }
          }
        }
        setState(() {
          isloadingblocklist = false;
        });
      }).catchError((e) {
        print(e.toString());
        setState(() {
          isloadingblocklist = false;
        });
      });
    } else {
      print("jj");
      getIntAsync(BLOCK_FORM_LAST_ID);
      fetchcustomerblockform(
              last_id: getIntAsync(BLOCK_FORM_LAST_ID),
              customer_id: getIntAsync(USER_ID))
          .then((value) {
        if (value.status == true) {
          List<BlockFormData>? blockformreloadlist;
          if (value.blockFormData != null) {
            setValue(BLOCK_FORM_LAST_ID, value.last_id);
            if (value.blockFormData!.isNotEmpty) {
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
                  images:
                      element.images == null ? [] : element.images!.toList(),
                ));
              }
              blockFormData = (blockFormData ?? []) + (blockformlist ?? []);
              setValue(BLOCK_FORM, jsonEncode(blockFormData));
              print("BLOCK_FORM_LIST: ${getStringAsync(BLOCK_FORM)}");
              final data = getStringAsync(BLOCK_FORM);
              if (!data.isEmptyOrNull) {
                print("here");
                blockformreloadlist = jsonDecode(data)
                    .map((item) => BlockFormData.fromJson(item))
                    .toList()
                    .cast<BlockFormData>();
                if (blockformreloadlist != null) {
                  if (blockformreloadlist.isNotEmpty) {
                    print("previous  customer list");
                    print(blockformlist!.length);
                    setState(() {
                      blockformlist = blockformreloadlist;
                      originalblockformlist = blockformlist;
                      //(blockformreloadlist ?? []) + (blockformlist ?? []);
                    });
                    print("updated customer list");
                    print(blockformlist!.length);
                  }
                }
              }
            }
          }
        }
        setState(() {
          isloadingblocklist = false;
        });
      }).catchError((e) {
        print(e.toString());
        setState(() {
          isloadingblocklist = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: AddFloatingButton(
          icon: Icons.question_answer_outlined,
          onTap: () async {
            await sendInquiry();
          },
        ),
        body: LiquidPullToRefresh(
          color: Colors.white,
          height: 100,
          animSpeedFactor: 2,
          backgroundColor: Colors.orange,
          showChildOpacityTransition: true,
          onRefresh: _reload,
          child: body().paddingOnly(left: 16, right: 16, top: 16),
        ),
      ),
    );
  }
}
