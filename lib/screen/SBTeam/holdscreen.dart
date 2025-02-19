import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_options.dart';
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

class HoldScreen extends StatefulWidget {
  const HoldScreen({super.key});

  @override
  _HoldScreenState createState() => _HoldScreenState();
}

class _HoldScreenState extends State<HoldScreen> {
  bool isLoading = false;
  List<BlockFormData> holdlist = [];
  int? last_id;
  List<BlockFormData> originalholdlist = [];
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
    await fetchholdblockform(last_id: null).then((value) {
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
              holdby: element.holdby == null ? [] : element.holdby!.toList(),
            ));
          }
          print(blockFormData[0].block_name.toString());
          setState(() {
            last_id = value.last_id;
            holdlist = blockFormData;
            originalholdlist = blockFormData;
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
      holdlist = originalholdlist;
      setState(() {});
      return;
    }
    query = query.toLowerCase();
    print(query);
    List<BlockFormData> result = [];
    for (var element in holdlist) {
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
          holdby: element.holdby == null ? [] : element.holdby!.toList(),
        ));
      }
    }
    holdlist = result;
    setState(() {});
  }

  Widget holdblock(BuildContext context) {
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
          itemCount: holdlist.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(defaultRadius),
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
                                  _image = holdlist[index]
                                          .images!
                                          .first
                                          .image
                                          .validate() ?? '';
                                });
                              },
                              onLongPressEnd: (details) {
                                print('Long Press End');
                                setState(() {
                                  is_long_press = false;
                                  _image = holdlist[index]
                                          .images!
                                          .first
                                          .image
                                          .validate() ?? '';
                                });
                              },
                              onTap: () {
                                print("On Tap");
                                QuickViewImagesWidget(
                                        blockFormImages:
                                            holdlist[index].images)
                                    .launch(context);
                              },
                              child: holdlist[index].images == null
                                  ? Container()
                                  : holdlist[index].images!.isEmpty
                                      ? Container()
                                      : holdlist[index].images!.isNotEmpty
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  34,
                                              child: cs.CarouselSlider.builder(
                                                carouselController: _controller,
                                                // padding: const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
                                                itemCount: holdlist[index]
                                                    .images!
                                                    .length,
                                                options: CarouselOptions(
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
                                                      holdlist[index]
                                                                  .images!
                                                                  .length >
                                                              10
                                                          ? 10
                                                          : holdlist[index]
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
                                                          child: holdlist[
                                                                          index]
                                                                      .images![
                                                                          indexdata]
                                                                      .image
                                                                      .validate()
                                                                      .contains(
                                                                          '.mp4') ||
                                                                  holdlist[
                                                                          index]
                                                                      .images![
                                                                          indexdata]
                                                                      .image
                                                                      .validate()
                                                                      .contains(
                                                                          '.MP4') ||
                                                                  holdlist[
                                                                          index]
                                                                      .images![
                                                                          indexdata]
                                                                      .image
                                                                      .validate()
                                                                      .contains(
                                                                          '.MOV') ||
                                                                  holdlist[
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
                                                                    url: holdlist[index]
                                                                            .images![indexdata]
                                                                            .image
                                                                            .validate() ?? '',
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
                                                                  url: holdlist[index]
                                                                              .images![
                                                                                  indexdata]
                                                                              .image ==
                                                                          null
                                                                      ? ''
                                                                      : holdlist[
                                                                              index]
                                                                          .images![
                                                                              indexdata]
                                                                          .image
                                                                          .validate(),
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
                                    holdlist[index].product_name.validate().toUpperCase(),
                                    style: boldTextStyle(size: titleTextSize),
                                  ),
                                  24.height,
                                ],
                              ),
                              Wrap(
                                runSpacing: 10,
                                children: [
                                  // CommonRowWidget(title: 'Form ID: ', value: '${holdlist![index].id.validate()}'),
                                  CommonRowWidget(
                                    title: 'Block Number: ',
                                    value:
                                        ' ${holdlist[index].block_name.validate()}',
                                  ),
                                  // CommonRowWidget(
                                  //   title: 'Product Name: ',
                                  //   value: ' ${holdlist![index].product_name.validate()}',
                                  // ),

                                  CommonRowWidget(
                                      title: "Slab Size: ",
                                      value:
                                          "${holdlist[index].slab_length.validate()}x${holdlist[index].slab_height.validate()} (In Inch)"),
                                  CommonRowWidget(
                                    title: 'Slab Thickness: ',
                                    value:
                                        '${holdlist[index].slab_thickness.validate()} (In Cm)',
                                  ),
                                  CommonRowWidget(
                                    title: 'Total Slabs: ',
                                    value:
                                        holdlist[index].total_slabs.validate(),
                                  ),
                                  CommonRowWidget(
                                    title: 'Total Sq ft: ',
                                    value:
                                        '${((int.parse(holdlist[index].total_slabs.validate()) * int.parse(holdlist[index].slab_length.validate()) * int.parse(holdlist[index].slab_height.validate())).toInt() / 144).toInt()}',
                                  ),
                                  if (holdlist[index].holdby != null &&
                                      holdlist[index].holdby!.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Divider(
                                          thickness: 2,
                                        ),
                                        Text(
                                          "Hold By Information: ",
                                          style: boldTextStyle(
                                              size: titleTextSize),
                                        ),
                                        5.height,
                                        if (holdlist[index]
                                                .holdby!
                                                .first
                                                .firstname !=
                                            null)
                                          CommonRowWidget(
                                            title: 'Name: ',
                                            value:
                                                '${holdlist[index].holdby!.first.firstname.validate().capitalizeFirstLetter()} ${holdlist[index].holdby!.first.lastname.validate().capitalizeFirstLetter()}',
                                          ),
                                        5.height,
                                        if (holdlist[index]
                                                .holdby!
                                                .first
                                                .whatsapp_number !=
                                            null)
                                          CommonRowWidget(
                                            title: 'Whatsapp Number: ',
                                            value:
                                                holdlist[index].holdby!.first.whatsapp_number.validate(),
                                          ),
                                        5.height,
                                        if (holdlist[index]
                                                .holdby!
                                                .first
                                                .email !=
                                            null)
                                          CommonRowWidget(
                                            title: 'Email Number: ',
                                            value:
                                                holdlist[index].holdby!.first.email.validate(),
                                          ),
                                        5.height,
                                        if (holdlist[index]
                                                .holdby!
                                                .first
                                                .role !=
                                            null)
                                          CommonRowWidget(
                                            title: 'Hold By Role: ',
                                            value:
                                                holdlist[index].holdby!.first.role.validate().capitalizeFirstLetter(),
                                          ),
                                      ],
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
                              holdlist[index].form_status == "On Hold")
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                  boxShape: BoxShape.circle,
                                  backgroundColor: kPrimaryColor),
                              padding: const EdgeInsets.all(10),
                              child: Image.asset("assets/icons/unhold.png",
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
                                  await unholdblock(
                                          form_id: holdlist[index].id)
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
                                    'Are you sure you wants to mark unhold to this block data' '?',
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
                                  if (getStatusData(holdlist[index]
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
                                          getStatusData(holdlist[index]
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
                                    blockFormData: holdlist[index]);
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
                            EditBlockFormScreen(blockFormData: holdlist[index])
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
                                await deleteblock(form_id: holdlist[index].id)
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
                                  'Are you sure you wants to delete this block data' '?',
                            );
                          }),
                        ],
                      ).paddingAll(16),
                    ],
                  ),
                ).paddingBottom(30),
                if (getStatusData(holdlist[index].form_status.validate())! !=
                    '')
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: statusBgColor,
                        borderRadius:
                            const BorderRadius.only(topRight: Radius.circular(1)),
                      ),
                      child: Text(
                          getStatusData(
                              holdlist[index].form_status.validate())!,
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
    } else    return '';
  
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
              'Total Hold Blocks' ' (${holdlist.length})',
              style: boldTextStyle(size: titleTextSize),
            ).paddingOnly(left: 16, right: 16, top: 16),
            24.height,
            holdblock(context)
                .visible(
                  holdlist != null,
                  defaultWidget: const NoDataFoundWidget(iconSize: 120).center(),
                )
                .paddingOnly(left: 16, right: 16, top: 16),
          ]),
    );
  }

  Future reload() async {
    await fetchholdblockform(last_id: null).then((value) {
      setState(() {
        isLoading = true;
      });
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
              holdby: element.holdby == null ? [] : element.holdby!.toList(),
            ));
          }
          if (blockFormData.isNotEmpty) {
            setState(() {
              holdlist = blockFormData;
            });
          }
                } else {
          setState(() {
            isLoading = false;
            holdlist = [];
          });
          toast("Empty Data");
        }
      } else {
        setState(() {
          isLoading = false;
          holdlist = [];
        });
        toast("Empty Data");
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
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
                holdby: element.holdby == null ? [] : element.holdby!.toList(),
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
    await fetchholdblockform(last_id: last_id).then((value) {
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
              holdby: element.holdby == null ? [] : element.holdby!.toList(),
            ));
          }
          if (blockFormData.isNotEmpty) {
            setState(() {
              holdlist = (blockFormData ?? []) + (holdlist ?? []);
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
        appBar: appAppBar(context, name: 'Hold Form List'),
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
