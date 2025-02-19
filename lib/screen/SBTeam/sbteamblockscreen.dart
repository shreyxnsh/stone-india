import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/blockform.dart';
import 'package:stoneindia/screen/SBTeam/blockformadd.dart';
import 'package:stoneindia/screen/SBTeam/blockformlist.dart';
import 'package:stoneindia/screen/SBTeam/sbteamdashboard.dart';
import 'package:stoneindia/screen/signin.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:stoneindia/widget/nodatafound.dart';

class SBTeamBlockScreen extends StatefulWidget {
  final bool? runHomeApi;
  final bool? isfilter;
  final String? typeSelected;
  final String? productSelected;
  final String? blockSelected;
  final String? categorySelected;
  final String? slabSelected;
  final String? thicknessSelected;
  final String? date;
  const SBTeamBlockScreen(
      {super.key,
      this.runHomeApi,
      this.isfilter,
      this.typeSelected,
      this.productSelected,
      this.blockSelected,
      this.categorySelected,
      this.slabSelected,
      this.thicknessSelected,
      this.date});

  @override
  _SBTeamBlockScreenState createState() => _SBTeamBlockScreenState();
}

class _SBTeamBlockScreenState extends State<SBTeamBlockScreen> {
  TextEditingController searchCont = TextEditingController();
  bool isloadingblock = false;
  bool isloadingproduct = false;
  bool isloadingcategory = false;
  bool isloadingslabs = false;
  bool isloadingthickness = false;
  bool isloadingserverproduct = false;
  bool isloadingserverblock = false;
  bool isloadingblocklist = false;
  List<BlockFormData>? blockformlist;
  List<BlockFormData>? originalblockformlist;
  bool isloading = false;
  bool filter = false;
  int? total_block_form_count = 0;
  TextEditingController txtQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      isloading = true;
    });
    await checkIfAccountDelte();
    print("jijij ggg");
    print(widget.typeSelected);
    print(widget.blockSelected);
    filter = widget.isfilter == null ? false : widget.isfilter!;
    if (widget.runHomeApi == true) {
      await fetchblockdata();
      await fetchproductdata();
      await fetchcategorydata();
      await fetchslabdata();
      await fetchthicknessdata();
      // await fetchserverproductdata();
      // await fetchserverblockdata();
      await fetchblocklistdata();
    } else {
      final data = getStringAsync(BLOCK_FORM_LIST);
      if (!data.isEmptyOrNull) {
        print("ijij");
        setState(() {
          blockformlist = jsonDecode(data)
              .map((item) => BlockFormData.fromJson(item))
              .toList()
              .cast<BlockFormData>();
          originalblockformlist = blockformlist;
        });
        print(blockformlist!.first.block_name);
        if (blockformlist == null) {
          print("null");
        }
      }
    }

    setState(() {
      isloading = false;
    });
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

  fetchthicknessdata() async {
    setState(() {
      isloadingthickness = true;
    });
    await fetchthicknesslist().then((value) {
      if (value.status == true) {
        if (value.thicknessData != null) {
          if (value.thicknessData!.isNotEmpty) {
            List<String> list = [];
            for (var element in value.thicknessData!) {
              list.add(element.thickness_name.toString());
            }
            setValue(THICKNESS_LIST, list);
            print("THICKNESS LIST: ${getStringListAsync(THICKNESS_LIST)}");
          }
        }
      }
      setState(() {
        isloadingthickness = false;
      });
    }).catchError((e) {
      setState(() {
        isloadingthickness = false;
      });
      log(e.toString());
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
            print("BLOCK LIST: ${getStringListAsync(BLOCK_LIST)}");
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

  fetchserverproductdata() async {
    setState(() {
      isloadingserverproduct = true;
    });
    await fetchserverproduct().then((value) {
      print("VALUE: $value");
      List productListData = [];
      productListData = value;
      setValue(SERVER_PRODUCT_LIST, productListData);
      setState(() {
        isloadingserverproduct = false;
      });
    }).catchError((e) {
      setState(() {
        isloadingserverproduct = false;
      });
      log(e.toString());
    });
  }

  fetchserverblockdata() async {
    setState(() {
      isloadingserverblock = true;
    });
    await fetchserverblock().then((value) {
      print(value);
      List blockListData = [];
      blockListData = value;
      setValue(SERVER_BLOCK_LIST, blockListData);
      print("blockListData: $blockListData");
      setState(() {
        isloadingserverblock = false;
      });
    }).catchError((e) {
      setState(() {
        isloadingserverblock = false;
      });
      log(e.toString());
    });
  }

  fetchblocklistdata() async {
    setState(() {
      isloadingblocklist = true;
    });
    fetchblockform().then((value) {
      if (value.status == true) {
        if (value.blockFormData != null) {
          setValue(BLOCK_FORM_LIST_LAST_ID, value.last_id);
          setValue(TEAM_TOTAL_BLOCK_FORM_COUNT, value.total_block_form_count);
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
                upload_date: element.upload_date,
                images: element.images == null ? [] : element.images!.toList(),
              ));
            }
            setValue(BLOCK_FORM_LIST, jsonEncode(blockFormData));
            print("BLOCK_FORM_LIST: ${getStringAsync(BLOCK_FORM_LIST)}");
            final data = getStringAsync(BLOCK_FORM_LIST);
            print("fdrfrfd");
            if (!data.isEmptyOrNull) {
              print("iamherr");
              setState(() {
                blockformlist = jsonDecode(data)
                    .map((item) => BlockFormData.fromJson(item))
                    .toList()
                    .cast<BlockFormData>();
                originalblockformlist = blockformlist;
                filter = false;
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
    fetchblockform().then((value) {
      if (value.status == true) {
        if (value.blockFormData != null) {
          setValue(BLOCK_FORM_LIST_LAST_ID, value.last_id);
          setValue(TEAM_TOTAL_BLOCK_FORM_COUNT, value.total_block_form_count);
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
                upload_date: element.upload_date,
                images: element.images == null ? [] : element.images!.toList(),
              ));
            }
            setValue(BLOCK_FORM_LIST, jsonEncode(blockFormData));
            print(
                "BLOCK_FORM_LIST UPDATED REMOVE FILTER: ${getStringAsync(BLOCK_FORM_LIST)}");
            const SBTeamDashboard(runHomeApi: false, isfilter: false)
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (filter == true)
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
                if (widget.date != null)
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
                          child: Text(widget.date.toString(),
                              style: const TextStyle(fontSize: 16)))
                      .paddingOnly(left: 1, right: 1, bottom: 2),
              ],
            ),
          ),
        8.height,
        Text(
          'Total Blocks'
          ' (${getIntAsync(TEAM_TOTAL_BLOCK_FORM_COUNT)})', //' (${blockformlist!.length})',
          style: boldTextStyle(size: titleTextSize),
        ),
        // 24.height,
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
        8.height,
        Container(
          child: isloadingblock == true ||
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
              : blockformlist == null
                  ? Container()
                  : blockformlist!.isEmpty
                      ? Container()
                      : Expanded(
                          child:
                              BlockFormListWidget(blockFormData: blockformlist)
                                  .visible(
                            blockformlist != null,
                            defaultWidget:
                                const NoDataFoundWidget(iconSize: 120).center(),
                          ),
                        ),
        ),
      ],
    );
  }

  Future _reload() async {
    print('hi');
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
              last_id: getIntAsync(FILTER_LIST_LAST_ID))
          .then((value) {
        if (value.status == true) {
          if (value.blockFormData != null) {
            if (value.blockFormData!.isNotEmpty) {
              setValue(
                  TEAM_TOTAL_BLOCK_FORM_COUNT, value.total_block_form_count);
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
                  upload_date: element.upload_date,
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
      fetchblockform(last_id: getIntAsync(BLOCK_FORM_LIST_LAST_ID))
          .then((value) {
        if (value.status == true) {
          setValue(BLOCK_FORM_LIST_LAST_ID, value.last_id);
          setValue(TEAM_TOTAL_BLOCK_FORM_COUNT, value.total_block_form_count);
          List<BlockFormData>? blockformreloadlist;
          if (value.blockFormData != null) {
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
                  upload_date: element.upload_date,
                  images:
                      element.images == null ? [] : element.images!.toList(),
                ));
              }
              blockFormData = (blockFormData ?? []) + (blockformlist ?? []);
              setValue(BLOCK_FORM_LIST, jsonEncode(blockFormData));
              print("BLOCK_FORM_LIST: ${getStringAsync(BLOCK_FORM_LIST)}");
              final data = getStringAsync(BLOCK_FORM_LIST);
              if (!data.isEmptyOrNull) {
                print("here");
                blockformreloadlist = jsonDecode(data)
                    .map((item) => BlockFormData.fromJson(item))
                    .toList()
                    .cast<BlockFormData>();
                if (blockformreloadlist != null) {
                  if (blockformreloadlist.isNotEmpty) {
                    print("pevious list");
                    print(blockformlist!.length);
                    setState(() {
                      blockformlist = blockformreloadlist;
                      originalblockformlist = blockformlist;
                      //(blockformreloadlist ?? []) + (blockformlist ?? []);
                    });
                    print("updated list");
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
          onTap: () {
            const AddBlockFormScreen().launch(context);
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
