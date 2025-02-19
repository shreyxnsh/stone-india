import 'dart:convert';

// import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/blockform.dart';
import 'package:stoneindia/screen/SBTeam/blockformedit.dart';
import 'package:stoneindia/screen/SBTeam/blockformquickview.dart';
import 'package:stoneindia/screen/quickviewimages.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/cachedimage.dart';
import 'package:stoneindia/widget/cachedvideo.dart';
import 'package:stoneindia/widget/commonrow.dart';
import 'package:intl/intl.dart';

class BlockFormListWidget extends StatefulWidget {
  List<BlockFormData>? blockFormData;

  BlockFormListWidget({super.key, this.blockFormData});

  @override
  _BlockFormListWidgetState createState() => _BlockFormListWidgetState();
}

class _BlockFormListWidgetState extends State<BlockFormListWidget> {
  bool is_long_press = false;
  String _image = "";
  bool isloadingblocklist = false;
  List<BlockFormData>? blockformlist;
  final cs.CarouselController _controller = cs.CarouselController();
  bool isWhatsappApi = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // print(widget.blockFormData!.first.images!.first.toString());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return isloadingblocklist
        ? const Center(
            child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: kPrimaryColor,
              strokeWidth: 2,
            ),
          ))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: widget.blockFormData!.length,
            // physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  Container(
                    // padding: EdgeInsets.all(16),
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
                                    _image = widget.blockFormData![index]
                                            .images!.first.image
                                            .validate() ??
                                        '';
                                  });
                                },
                                onLongPressEnd: (details) {
                                  print('Long Press End');
                                  setState(() {
                                    is_long_press = false;
                                    _image = widget.blockFormData![index]
                                            .images!.first.image
                                            .validate() ??
                                        '';
                                  });
                                },
                                onTap: () {
                                  print("On Tap");
                                  QuickViewImagesWidget(
                                          blockFormImages: widget
                                              .blockFormData![index].images)
                                      .launch(context);
                                },
                                child:
                                    widget.blockFormData![index].images == null
                                        ? Container()
                                        : widget.blockFormData![index].images!
                                                .isEmpty
                                            ? Container()
                                            : widget.blockFormData![index]
                                                    .images!.isNotEmpty
                                                ? SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            32,
                                                    child: cs.CarouselSlider
                                                        .builder(
                                                      carouselController:
                                                          _controller,
                                                      // padding: const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
                                                      itemCount: widget
                                                          .blockFormData![index]
                                                          .images!
                                                          .length,
                                                      options:
                                                          cs.CarouselOptions(
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
                                                          int indexdata,
                                                          realIdx) {
                                                        final int count = widget
                                                                    .blockFormData![
                                                                        index]
                                                                    .images!
                                                                    .length >
                                                                10
                                                            ? 10
                                                            : widget
                                                                .blockFormData![
                                                                    index]
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
                                                                child: widget
                                                                            .blockFormData![
                                                                                index]
                                                                            .images![
                                                                                indexdata]
                                                                            .image
                                                                            .validate()
                                                                            .contains(
                                                                                '.mp4') ||
                                                                        widget
                                                                            .blockFormData![
                                                                                index]
                                                                            .images![
                                                                                indexdata]
                                                                            .image
                                                                            .validate()
                                                                            .contains(
                                                                                '.MP4') ||
                                                                        widget
                                                                            .blockFormData![
                                                                                index]
                                                                            .images![
                                                                                indexdata]
                                                                            .image
                                                                            .validate()
                                                                            .contains(
                                                                                '.MOV') ||
                                                                        widget
                                                                            .blockFormData![
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
                                                                        height:
                                                                            300,
                                                                        width: MediaQuery.of(context).size.width -
                                                                            50,
                                                                        child:
                                                                            CachedVideoWidget(
                                                                          url: widget.blockFormData![index].images![indexdata].image.validate() ??
                                                                              '',
                                                                          height:
                                                                              300,
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          radius:
                                                                              1,
                                                                        ),
                                                                      ))
                                                                    : CachedImageWidget(
                                                                        url: widget.blockFormData![index].images![indexdata].image.validate() ??
                                                                            '',
                                                                        height:
                                                                            300,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        radius:
                                                                            1,
                                                                      ),
                                                              )
                                                            ]);
                                                      },
                                                    ),
                                                  )
                                                : Container()),
                          ],
                        ),
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
                                      widget.blockFormData![index].product_name
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
                                    // CommonRowWidget(title: 'Form ID: ', value: '${widget.blockFormData![index].id.validate()}'),
                                    CommonRowWidget(
                                      title: 'Block Number: ',
                                      value:
                                          ' ${widget.blockFormData![index].block_name.validate()}',
                                    ),
                                    // CommonRowWidget(
                                    //   title: 'Product Name: ',
                                    //   value: ' ${widget.blockFormData![index].product_name.validate()}',
                                    // ),

                                    CommonRowWidget(
                                        title: "Slab Size: ",
                                        value:
                                            "${widget.blockFormData![index].slab_length.validate()}x${widget.blockFormData![index].slab_height.validate()} (In Inch)"),
                                    CommonRowWidget(
                                      title: 'Slab Thickness: ',
                                      value:
                                          '${widget.blockFormData![index].slab_thickness.validate()} (In Cm)',
                                    ),
                                    CommonRowWidget(
                                      title: 'Total Slabs: ',
                                      value: widget
                                          .blockFormData![index].total_slabs
                                          .validate(),
                                    ),
                                    CommonRowWidget(
                                      title: 'Total Sq ft: ',
                                      value:
                                          '${((int.parse(widget.blockFormData![index].total_slabs.validate()) * int.parse(widget.blockFormData![index].slab_length.validate()) * int.parse(widget.blockFormData![index].slab_height.validate())).toInt() / 144).toInt()}',
                                    ),
                                    if (getStringAsync(USER_ROLE) == 'team' &&
                                        widget.blockFormData![index]
                                                .upload_date !=
                                            null)
                                      CommonRowWidget(
                                        title: 'Upload Date: ',
                                        value: DateFormat('d MMM yyyy').format(
                                            DateTime.parse(widget
                                                .blockFormData![index]
                                                .upload_date
                                                .validate()
                                                .split('T')[0])),
                                      ),
                                  ],
                                ),
                              ],
                            ).expand(),
                          ],
                        ).paddingAll(16),
                        // 16.height,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (getStringAsync(USER_ROLE) ==
                                      UserRoleStoneBharatTeam &&
                                  (widget.blockFormData![index].form_status ==
                                          null ||
                                      widget.blockFormData![index]
                                              .form_status ==
                                          "On Hold"))
                                Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: kPrimaryColor),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset("assets/icons/sold.png",
                                      width: 15,
                                      height: 15,
                                      fit: BoxFit.cover,
                                      color: white),
                                ).onTap(() async {
                                  showConfirmDialogCustom(
                                    context,
                                    primaryColor: kPrimaryColor,
                                    negativeText: 'Cancel',
                                    positiveText: 'Yes',
                                    onAccept: (c) async {
                                      await soldblock(
                                              form_id: widget
                                                  .blockFormData![index].id,
                                              team_id: getIntAsync(USER_ID))
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
                                        'Are you sure you wants to mark sold to this block data'
                                        '?',
                                  );
                                }),
                              if (getStringAsync(USER_ROLE) ==
                                      UserRoleStoneBharatTeam &&
                                  widget.blockFormData![index].form_status ==
                                      "On Sold")
                                Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: kPrimaryColor),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset("assets/icons/unsold.png",
                                      width: 15,
                                      height: 15,
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
                                              form_id: widget
                                                  .blockFormData![index].id,
                                              team_id: getIntAsync(USER_ID))
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
                                        'Are you sure you wants to mark unsold to this block data'
                                        '?',
                                  );
                                }),
                              18.width,
                              if (getStringAsync(USER_ROLE) ==
                                      UserRoleStoneBharatTeam &&
                                  widget.blockFormData![index].form_status ==
                                      "On Hold")
                                Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: kPrimaryColor),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset("assets/icons/unhold.png",
                                      width: 15,
                                      height: 15,
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
                                              form_id: widget
                                                  .blockFormData![index].id)
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
                                        'Are you sure you wants to mark unhold to this block data'
                                        '?',
                                  );
                                }),
                              if (getStringAsync(USER_ROLE) ==
                                      UserRoleStoneBharatTeam &&
                                  (widget.blockFormData![index].form_status ==
                                          null ||
                                      widget.blockFormData![index]
                                              .form_status ==
                                          "On Sold"))
                                Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: kPrimaryColor),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset("assets/icons/privacy.png",
                                      width: 15,
                                      height: 15,
                                      fit: BoxFit.cover,
                                      color: white),
                                ).onTap(() async {
                                  showConfirmDialogCustom(
                                    context,
                                    primaryColor: kPrimaryColor,
                                    negativeText: 'Cancel',
                                    positiveText: 'Yes',
                                    onAccept: (c) async {
                                      await holdblockteam(
                                              form_id: widget
                                                  .blockFormData![index].id,
                                              team_id: getIntAsync(USER_ID))
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
                                        'Are you sure you wants to mark hold to this block data'
                                        '?',
                                  );
                                }),
                              18.width,
                              Container(
                                decoration: boxDecorationWithRoundedCorners(
                                    boxShape: BoxShape.circle,
                                    backgroundColor: kPrimaryColor),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/icons/view.png",
                                    width: 15,
                                    height: 15,
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
                                                    backgroundColor:
                                                        kPrimaryColor),
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
                                                  style:
                                                      boldTextStyle(size: 18))
                                              .flexible(),
                                        ],
                                      ).paddingOnly(top: 24),
                                      if (getStatusData(widget
                                              .blockFormData![index].form_status
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
                                              getStatusData(widget
                                                  .blockFormData![index]
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
                                        blockFormData:
                                            widget.blockFormData![index]);
                                  },
                                );
                              }),
                              18.width,
                              if (getStringAsync(USER_ROLE) ==
                                  UserRoleStoneBharatTeam)
                                Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: kPrimaryColor),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset("assets/icons/edit.png",
                                      width: 15,
                                      height: 15,
                                      fit: BoxFit.cover,
                                      color: white),
                                ).onTap(() {
                                  EditBlockFormScreen(
                                          blockFormData:
                                              widget.blockFormData![index])
                                      .launch(context);
                                }),
                              if (getStringAsync(USER_ROLE) ==
                                  UserRoleStoneBharatTeam)
                                18.width,
                              if (getStringAsync(USER_ROLE) ==
                                  UserRoleStoneBharatTeam)
                                Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: kPrimaryColor),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset("assets/icons/delete.png",
                                      width: 15,
                                      height: 15,
                                      fit: BoxFit.cover,
                                      color: white),
                                ).onTap(() async {
                                  showConfirmDialogCustom(
                                    context,
                                    primaryColor: kPrimaryColor,
                                    negativeText: 'Cancel',
                                    positiveText: 'Yes',
                                    onAccept: (c) async {
                                      await deleteblock(
                                              form_id: widget
                                                  .blockFormData![index].id)
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
                              if (getStringAsync(USER_ROLE) ==
                                  UserRoleStoneBharatTeam)
                                18.width,
                              Container(
                                decoration: boxDecorationWithRoundedCorners(
                                    boxShape: BoxShape.circle,
                                    backgroundColor: kPrimaryColor),
                                child: Image.asset(
                                  "assets/icons/whatsapp.png",
                                  width: 34,
                                  height: 34,
                                  fit: BoxFit.cover,
                                ),
                              ).onTap(() async {
                                if (isWhatsappApi == true) {
                                  toast(
                                      "Sending media to your whatsapp is in progress..");
                                } else {
                                  setState(() {
                                    isWhatsappApi = true;
                                  });
                                  await getallphotosonwhatsapp(
                                          block_id:
                                              widget.blockFormData![index].id,
                                          user_id: getIntAsync(USER_ID))
                                      .then((value) {
                                    if (value["success"] == true) {
                                      toast("Photos sent successfully!");
                                      setState(() {
                                        isWhatsappApi = false;
                                      });
                                    }
                                  }).catchError((e) {
                                    toast(e.toString());
                                    setState(() {
                                      isWhatsappApi = false;
                                    });
                                  }).whenComplete(() {
                                    setState(() {
                                      isWhatsappApi = false;
                                    });
                                  });
                                }
                              }),
                              if (getStringAsync(USER_ROLE) == UserRoleCustomer)
                                18.width,
                              if (getStringAsync(USER_ROLE) == UserRoleCustomer)
                                Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: kPrimaryColor),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset("assets/icons/privacy.png",
                                      width: 15,
                                      height: 15,
                                      fit: BoxFit.cover,
                                      color: white),
                                ).onTap(() async {
                                  showConfirmDialogCustom(
                                    context,
                                    primaryColor: kPrimaryColor,
                                    negativeText: 'Cancel',
                                    positiveText: 'Yes',
                                    onAccept: (c) async {
                                      await holdblock(
                                              form_id: widget
                                                  .blockFormData![index].id,
                                              customer_id: getIntAsync(USER_ID))
                                          .then((value) {
                                        toast(value["messages"].toString());
                                      }).catchError((e) {
                                        setState(() {});
                                        log(e.toString());
                                      });
                                    },
                                    title:
                                        'Are you sure you wants to hold this block for you'
                                        '?',
                                  );
                                }),
                            ],
                          ).paddingAll(16),
                        )
                      ],
                    ),
                  ).paddingBottom(30),
                  if (getStatusData(widget.blockFormData![index].form_status
                          .validate())! !=
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
                            getStatusData(widget
                                .blockFormData![index].form_status
                                .validate())!,
                            style: boldTextStyle(size: 12, color: white)),
                      ),
                    ),
                ],
              );
            },
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

  fetchblocklistdata() async {
    setState(() {
      isloadingblocklist = true;
    });
    fetchblockform().then((value) {
      if (value.status == true) {
        setValue(BLOCK_FORM_LIST_LAST_ID, value.last_id);
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
            setValue(BLOCK_FORM_LIST, jsonEncode(blockFormData));
            print("BLOCK_FORM_LIST Delete: ${getStringAsync(BLOCK_FORM_LIST)}");
            final data = getStringAsync(BLOCK_FORM_LIST);
            if (!data.isEmptyOrNull) {
              print("here");
              setState(() {
                blockformlist = jsonDecode(data)
                    .map((item) => BlockFormData.fromJson(item))
                    .toList()
                    .cast<BlockFormData>();
              });
              print(blockformlist);
              print(blockformlist!.length);
              if (blockformlist != null) {
                print("not null");
                setState(() {
                  widget.blockFormData = blockformlist;
                });
              }
            }
          }
        }
        setState(() {
          isloadingblocklist = false;
        });
      } else {
        setState(() {
          isloadingblocklist = false;
        });
      }
    }).catchError((e) {
      print(e.toString());
      setState(() {
        isloadingblocklist = false;
      });
    });
  }
}
