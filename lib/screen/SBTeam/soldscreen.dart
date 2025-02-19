import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/blockform.dart';
import 'package:stoneindia/screen/SBTeam/blockformedit.dart';
import 'package:stoneindia/screen/SBTeam/blockformquickview.dart';
import 'package:stoneindia/screen/quickviewimages.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:stoneindia/widget/cachedimage.dart';
import 'package:stoneindia/widget/cachedvideo.dart';
import 'package:stoneindia/widget/commonrow.dart';
import 'package:stoneindia/widget/nodatafound.dart';

class SoldScreen extends StatefulWidget {
  const SoldScreen({super.key});

  @override
  _SoldScreenState createState() => _SoldScreenState();
}

class _SoldScreenState extends State<SoldScreen> {
  bool isLoading = false;
  List<BlockFormData> soldlist = [];
  int? last_id;
  List<BlockFormData> originalsoldlist = [];
  TextEditingController txtQuery = TextEditingController();
  var formKey = GlobalKey<FormState>();
  TextEditingController nameCont = TextEditingController();
  FocusNode nameFocus = FocusNode();
  bool is_long_press = false;
  String _image = "";
  final cs.CarouselController _controller = cs.CarouselController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    setStatusBarColor(scaffoldBgColor,
        statusBarIconBrightness: Brightness.light);
    await fetchsoldblockform(last_id: null).then((value) {
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
              images: element.images == null ? [] : element.images!.toList(),
            ));
          }
          print(blockFormData[0].block_name.toString());
          setState(() {
            last_id = value.last_id;
            soldlist = blockFormData;
            originalsoldlist = blockFormData;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          toast("Empty Data");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        toast("Empty Data");
      }
    }).catchError((e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
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
      soldlist = originalsoldlist;
      setState(() {});
      return;
    }
    query = query.toLowerCase();
    print(query);
    List<BlockFormData> result = [];
    for (var element in soldlist) {
      var name = element.block_name.toString().toLowerCase();
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
          images: element.images == null ? [] : element.images!.toList(),
        ));
      }
    }
    soldlist = result;
    setState(() {});
  }

  Widget soldblockformlist(BuildContext context) {
    return Column(
      children: [
        if (is_long_press) ...[
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          Container(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  _image,
                  height: 300,
                  width: 300,
                ),
              ),
            ),
          ),
        ],
        ListView.builder(
          shrinkWrap: true,
          itemCount: soldlist.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(1),
                    spreadRadius: 0,
                    blurRadius: 0,
                    backgroundColor: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onLongPress: () {
                                print('Long Press Begin');
                                setState(() {
                                  is_long_press = true;
                                  _image = soldlist[index]
                                          .images!
                                          .first
                                          .image
                                          .validate() ??
                                      '';
                                });
                              },
                              onLongPressEnd: (details) {
                                print('Long Press End');
                                setState(() {
                                  is_long_press = false;
                                  _image = soldlist[index]
                                          .images!
                                          .first
                                          .image
                                          .validate() ??
                                      '';
                                });
                              },
                              onTap: () {
                                print("On Tap");
                                QuickViewImagesWidget(
                                        blockFormImages: soldlist[index].images)
                                    .launch(context);
                              },
                              child: soldlist[index].images == null
                                  ? Container()
                                  : soldlist[index].images!.isEmpty
                                      ? Container()
                                      : soldlist[index].images!.isNotEmpty
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  34,
                                              child: cs.CarouselSlider.builder(
                                                carouselController: _controller,
                                                // padding: const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
                                                itemCount: soldlist[index]
                                                    .images!
                                                    .length,
                                                options: cs.CarouselOptions(
                                                  // height: MediaQuery.of(context).size.height*0.25,
                                                  autoPlayInterval:
                                                      const Duration(
                                                          seconds: 15),
                                                  height: 280,
                                                  autoPlay: true,
                                                  viewportFraction: 1,
                                                  initialPage: 1,
                                                  aspectRatio: 2.0,
                                                  enlargeCenterPage: true,
                                                ),
                                                itemBuilder: (context,
                                                    int indexdata, realIdx) {
                                                  final int count =
                                                      soldlist[index]
                                                                  .images!
                                                                  .length >
                                                              10
                                                          ? 10
                                                          : soldlist[index]
                                                              .images!
                                                              .length;
                                                  return ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      children: [
                                                        Center(
                                                          child: soldlist[
                                                                          index]
                                                                      .images![
                                                                          indexdata]
                                                                      .image
                                                                      .validate()
                                                                      .contains(
                                                                          '.mp4') ||
                                                                  soldlist[
                                                                          index]
                                                                      .images![
                                                                          indexdata]
                                                                      .image
                                                                      .validate()
                                                                      .contains(
                                                                          '.MP4') ||
                                                                  soldlist[
                                                                          index]
                                                                      .images![
                                                                          indexdata]
                                                                      .image
                                                                      .validate()
                                                                      .contains(
                                                                          '.MOV') ||
                                                                  soldlist[
                                                                          index]
                                                                      .images![
                                                                          indexdata]
                                                                      .image
                                                                      .validate()
                                                                      .contains(
                                                                          '.mov')
                                                              ? IgnorePointer(
                                                                  child:
                                                                      SizedBox(
                                                                  height: 300,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child:
                                                                      CachedVideoWidget(
                                                                    url: soldlist[index]
                                                                            .images![indexdata]
                                                                            .image
                                                                            .validate() ??
                                                                        '',
                                                                    height: 300,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        50,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    radius: 1,
                                                                  ),
                                                                ))
                                                              : CachedImageWidget(
                                                                  url: soldlist[
                                                                              index]
                                                                          .images![
                                                                              indexdata]
                                                                          .image
                                                                          .validate() ??
                                                                      '',
                                                                  height: 300,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  radius: 1,
                                                                ),
                                                        )
                                                      ]);
                                                },
                                              ),
                                            )
                                          : Container()),
                        ],
                      ),
                      10.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  20.height,
                                  Text(
                                    soldlist[index]
                                        .product_name
                                        .validate()
                                        .toUpperCase(),
                                    style: boldTextStyle(size: titleTextSize),
                                  ),
                                  24.height,
                                ],
                              ),
                              Wrap(
                                runSpacing: 10,
                                children: [
                                  // CommonRowWidget(title: 'Form ID: ', value: '${soldlist![index].id.validate()}'),
                                  CommonRowWidget(
                                    title: 'Block Number: ',
                                    value:
                                        ' ${soldlist[index].block_name.validate()}',
                                  ),
                                  // CommonRowWidget(
                                  //   title: 'Product Name: ',
                                  //   value: ' ${soldlist![index].product_name.validate()}',
                                  // ),

                                  CommonRowWidget(
                                      title: "Slab Size: ",
                                      value:
                                          "${soldlist[index].slab_length.validate()}x${soldlist[index].slab_height.validate()} (In Inch)"),
                                  CommonRowWidget(
                                    title: 'Slab Thickness: ',
                                    value:
                                        '${soldlist[index].slab_thickness.validate()} (In Cm)',
                                  ),
                                  CommonRowWidget(
                                    title: 'Total Slabs: ',
                                    value:
                                        soldlist[index].total_slabs.validate(),
                                  ),
                                  CommonRowWidget(
                                    title: 'Total Sq ft: ',
                                    value:
                                        '${((int.parse(soldlist[index].total_slabs.validate()) * int.parse(soldlist[index].slab_length.validate()) * int.parse(soldlist[index].slab_height.validate())).toInt() / 144).toInt()}',
                                  ),
                                ],
                              ),
                            ],
                          ).expand(),
                        ],
                      ).paddingAll(16),
                      // 16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Spacer(),
                          if (getStringAsync(USER_ROLE) ==
                                  UserRoleStoneBharatTeam &&
                              soldlist[index].form_status == "On Sold")
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                  boxShape: BoxShape.circle,
                                  backgroundColor: kPrimaryColor),
                              padding: const EdgeInsets.all(10),
                              child: Image.asset("assets/icons/unsold.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                  color: white),
                            ).onTap(() async {
                              showConfirmDialogCustom(
                                context,
                                primaryColor: kPrimaryColor,
                                negativeText: 'Cancel',
                                positiveText: 'Yes',
                                onAccept: (c) async {
                                  await unsoldblock(
                                          form_id: soldlist[index].id,
                                          team_id: getIntAsync(USER_ID))
                                      .then((value) async {
                                    if (value["status"] == true) {
                                      await reload();
                                    }
                                    toast(value["messages"].toString());
                                  }).catchError((e) {
                                    setState(() {});
                                    log(e.toString());
                                  });
                                },
                                title:
                                    'Are you sure you wants to mark unsold to this block data'
                                    '?',
                              );
                            }),
                          24.width,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                                boxShape: BoxShape.circle,
                                backgroundColor: kPrimaryColor),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset("assets/icons/view.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                                color: white),
                          ).onTap(() {
                            showInDialog(
                              context,
                              contentPadding: EdgeInsets.zero,
                              title: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration:
                                            boxDecorationWithRoundedCorners(
                                                backgroundColor: kPrimaryColor),
                                        child: Image.asset(
                                          "assets/icons/blockfill.png",
                                          fit: BoxFit.cover,
                                          height: 22,
                                          width: 22,
                                          color: white,
                                        ),
                                      ),
                                      16.width,
                                      Text('Block Form Summary ',
                                              style: boldTextStyle(size: 18))
                                          .flexible(),
                                    ],
                                  ).paddingOnly(top: 24),
                                  if (getStatusData(soldlist[index]
                                          .form_status
                                          .validate())! !=
                                      '')
                                    Positioned(
                                      right: -24,
                                      top: -24,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration:
                                            boxDecorationWithRoundedCorners(
                                          backgroundColor: statusColor,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  defaultRadius)),
                                        ),
                                        child: Text(
                                          getStatusData(soldlist[index]
                                              .form_status
                                              .validate())!,
                                          style: boldTextStyle(
                                              size: 12, color: white),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              builder: (p0) {
                                return BlockFormQuickView(
                                    blockFormData: soldlist[index]);
                              },
                            );
                          }),
                          24.width,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                                boxShape: BoxShape.circle,
                                backgroundColor: kPrimaryColor),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset("assets/icons/edit.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                                color: white),
                          ).onTap(() {
                            EditBlockFormScreen(blockFormData: soldlist[index])
                                .launch(context);
                          }),
                          24.width,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                                boxShape: BoxShape.circle,
                                backgroundColor: kPrimaryColor),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset("assets/icons/delete.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                                color: white),
                          ).onTap(() async {
                            showConfirmDialogCustom(
                              context,
                              primaryColor: kPrimaryColor,
                              negativeText: 'Cancel',
                              positiveText: 'Yes',
                              onAccept: (c) async {
                                await deleteblock(form_id: soldlist[index].id)
                                    .then((value) async {
                                  if (value["status"] == true) {
                                    await fetchblocklistdata();
                                  }
                                  toast(value["messages"].toString());
                                }).catchError((e) {
                                  setState(() {});
                                  log(e.toString());
                                });
                              },
                              title:
                                  'Are you sure you wants to delete this block data'
                                  '?',
                            );
                          }),
                        ],
                      ).paddingAll(16),
                    ],
                  ),
                ).paddingBottom(30),
                if (getStatusData(soldlist[index].form_status.validate())! !=
                    '')
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: statusBgColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(1)),
                      ),
                      child: Text(
                          getStatusData(
                              soldlist[index].form_status.validate())!,
                          style: boldTextStyle(size: 12, color: white)),
                    ),
                  ),
              ],
            );
          },
        )
      ],
    );
  }

  String? getStatusData(String num) {
    if (num == 'On Hold') {
      return 'On Hold';
    } else if (num == 'On Sold') {
      return 'On Sold';
    } else
      return '';
  }

  Widget body() {
    return Column(
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
        Expanded(child: listdata())
      ],
    );
  }

  Widget listdata() {
    return SingleChildScrollView(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Hold Blocks' ' (${soldlist.length})',
              style: boldTextStyle(size: titleTextSize),
            ).paddingOnly(left: 16, right: 16, top: 16),
            24.height,
            soldblockformlist(context)
                .visible(
                  soldlist != null,
                  defaultWidget:
                      const NoDataFoundWidget(iconSize: 120).center(),
                )
                .paddingOnly(left: 16, right: 16, top: 16),
          ]),
    );
  }

  Future reload() async {
    await fetchsoldblockform(last_id: null).then((value) {
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
              images: element.images == null ? [] : element.images!.toList(),
            ));
          }
          if (blockFormData.isNotEmpty) {
            setState(() {
              soldlist = blockFormData;
            });
          }
        } else {
          setState(() {
            isLoading = false;
            soldlist = [];
          });
          toast("Empty data");
        }
      } else {
        setState(() {
          isLoading = false;
          soldlist = [];
        });
        toast("Empty data");
      }
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() async {
      await fetchblocklistdata();
    });
  }

  fetchblocklistdata() async {
    setState(() {
      isLoading = true;
    });
    fetchblockform().then((value) {
      if (value.status == true) {
        if (value.blockFormData != null) {
          setValue(BLOCK_FORM_LIST_LAST_ID, value.last_id);
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
                images: element.images == null ? [] : element.images!.toList(),
              ));
            }
            setValue(BLOCK_FORM_LIST, jsonEncode(blockFormData));
            print("BLOCK_FORM_LIST: ${getStringAsync(BLOCK_FORM_LIST)}");
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    });
  }

  Future _reload() async {
    await fetchsoldblockform(last_id: last_id).then((value) {
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
              images: element.images == null ? [] : element.images!.toList(),
            ));
          }
          if (blockFormData.isNotEmpty) {
            setState(() {
              soldlist = (blockFormData ?? []) + (soldlist ?? []);
            });
          }
        }
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar(context, name: 'Sold Form List'),
        body: isLoading == true
            ? const Center(
                child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                  strokeWidth: 2,
                ),
              ))
            : LiquidPullToRefresh(
                color: Colors.white,
                height: 100,
                animSpeedFactor: 2,
                backgroundColor: Colors.orange,
                showChildOpacityTransition: true,
                onRefresh: _reload,
                child: body(),
              ),
      ),
    );
  }
}
