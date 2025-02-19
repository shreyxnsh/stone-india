import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/blockform.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:stoneindia/widget/cachedimage.dart';
import 'package:stoneindia/widget/cachedvideo.dart';
import 'package:stoneindia/widget/detailsphotoview.dart';
import 'package:stoneindia/widget/nodatafound.dart';

class QuickViewImagesWidget extends StatefulWidget {
  final List<BlockImages>? blockFormImages;

  const QuickViewImagesWidget({super.key, this.blockFormImages});

  @override
  _QuickViewImagesWidgetState createState() => _QuickViewImagesWidgetState();
}

class _QuickViewImagesWidgetState extends State<QuickViewImagesWidget> {

  List<String> mediaStatus = [];
  int selectIndex = -1;
  bool is_long_press = false;
  String _image = "";
  List<String> videoList = [];
  List<String> imageList = [];
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(scaffoldBgColor, statusBarIconBrightness: Brightness.light);
    setState(() {
      isloading = true;
    });
    mediaStatus.add("Images");
    mediaStatus.add("Video");
    selectIndex = 0;
    if(widget.blockFormImages!.first.image.validate().contains('.mp4') || widget.blockFormImages!.first.image.validate().contains('.MP4') || widget.blockFormImages!.first.image.validate().contains('.mov') || widget.blockFormImages!.first.image.validate().contains('.MOV')){
      selectIndex = 1;
    }
    if(widget.blockFormImages!.isNotEmpty){
      setState(() {
        List<String> imglist = [];
        List<String> vidlist = [];
        for (var element in widget.blockFormImages!) {
          if(element.image.validate().contains('.mp4') || element.image.validate().contains('.MP4') || element.image.validate().contains('.MOV') || element.image.validate().contains('.mov')){
            vidlist.add(element.image.validate().toString());
          }else if(element.image.validate().contains('.jpeg') || element.image.validate().contains('.jpg') || element.image.validate().contains('.png')){
            imglist.add(element.image.validate().toString());
          }
        }
        imageList = imglist;
        videoList = vidlist;
      });
    }else{
      setState(() {
        videoList = [];
        imageList = [];
      });
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(scaffoldBgColor,
      statusBarIconBrightness: Brightness.light,
    );
    super.dispose();
  }

  Widget ImageGridView() {
    return GridView.count(
          crossAxisCount: 2,
          children: List.generate(
            imageList.length, (index){
            return GestureDetector(
              onLongPress: () {
                print('Long Press Begin');
                setState(() {
                  is_long_press = true;
                  _image = imageList[index].toString();
                });
              },
              onLongPressEnd: (details) {
                print('Long Press End');
                setState(() {
                  is_long_press = false;
                  _image = imageList[index].toString();
                });
              },
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return DetailPhotoViewScreen(tag: "Image", url:imageList[index].toString() );
                }));
              },
              child: CachedImageWidget(
                url: imageList[index].toString(),
                height:300,
                width:300,
                fit: BoxFit.cover,
                radius: 10,
              ).paddingAll(2),
            );
            },
          ),
        ).visible(
      imageList.isNotEmpty,
      defaultWidget: const NoDataFoundWidget(iconSize: 120).center(),
    ).paddingAll(16);
  }

  Widget VideoGridView(){
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(
        videoList.length, (index){
        return CachedVideoWidget(
            url: videoList[index].toString(),
            height:300,
            width:300,
            fit: BoxFit.cover,
            radius: 10,
          );
      },
      ),
    ).visible(
      videoList.isNotEmpty,
      defaultWidget: const NoDataFoundWidget(iconSize: 120).center(),
    ).paddingAll(16);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar(context, name: 'Uploaded Media'),
        body: Center(
          child: isloading == true
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
          : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              HorizontalList(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: mediaStatus.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                    margin: const EdgeInsets.only(left: 0, right: 8, top: 4, bottom: 4),
                    decoration: BoxDecoration(
                      color: selectIndex == index
                          ? kPrimaryColor
                          : scaffoldBgColor,
                      borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
                    ),
                    child: FittedBox(
                      child: Text(
                        mediaStatus[index],
                        style: primaryTextStyle(size: 14, color: selectIndex == index ? white : Theme.of(context).iconTheme.color),
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
              10.height,
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
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ),
              ],
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: (selectIndex == 0)
                      ? (imageList.isNotEmpty)
                        ? ImageGridView()
                        : Container()
                      : (videoList.isNotEmpty)
                        ? VideoGridView()
                        : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}