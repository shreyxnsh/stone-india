// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:stoneindia/contants.dart';
// import 'package:stoneindia/main.dart';
// import 'package:stoneindia/model/blockform.dart';
// import 'package:stoneindia/model/servermedia.dart';
// import 'package:stoneindia/screen/SBTeam/sbteamdashboard.dart';
// import 'package:stoneindia/utils/restapi.dart';
// import 'package:stoneindia/widget/addfilterdialog.dart';
// import 'package:stoneindia/widget/appcommon.dart';
// import 'package:stoneindia/widget/cachedimage.dart';
// import 'package:stoneindia/widget/cachedvideo.dart';
// import 'package:stoneindia/widget/detailsphotoview.dart';
// import 'package:stoneindia/widget/nodatafound.dart';
//
// class EditImageBlockFormScreenOld extends StatefulWidget {
//
//   const EditImageBlockFormScreenOld({Key? key,
//     this.block_name,
//     this.product_name,
//     this.category_name,
//     this.form_type,
//     this.slab_type_name,
//     this.slab_height,
//     this.slab_length,
//     this.slab_thickness,
//     this.total_slabs
//   }) : super(key: key);
//
//   final String? block_name;
//   final String? product_name;
//   final String? category_name;
//   final String? form_type;
//   final String? slab_type_name;
//   final String? slab_height;
//   final String? slab_length;
//   final String? slab_thickness;
//   final String? total_slabs;
//
//   @override
//   _EditImageBlockFormScreenOldState createState() => _EditImageBlockFormScreenOldState();
// }
//
// class _EditImageBlockFormScreenOldState extends State<EditImageBlockFormScreenOld> with SingleTickerProviderStateMixin{
//   late TabController _tabController;
//   List<String> imagesList = [];
//   List<String> uploadedImageList = [];
//   String _error = 'No Error Detected';
//   List<String> imageStatus = [];
//   int selectIndex = -1;
//   bool is_long_press = false;
//   String _image = "";
//   bool is_select = false;
//   String _is_select_image = "";
//   bool is_gallary_image_long_press = false;
//   bool _is_select_gallary_image = false;
//   String _gallary_image = '';
//   List<String> mediaImageList = [];
//   List<String> videoList = [];
//   List<String> imageList = [];
//   String? nextUrl;
//   bool _isloading = false;
//   bool showSpinner = false;
//   bool isloadingblocklist = false;
//   bool isLoading = false;
//   ImagePicker _imagePicker = ImagePicker();
//
//   Future<void> getcam() async {
//     var img = await _imagePicker.getImage(source: ImageSource.camera);
//     setState(() {
//       if (img != null) {
//         uploadedImageList.add(img.path);
//       }
//     });
//   }
//
//   Future<void> getgallery() async {
//     var images = await _imagePicker.pickMultiImage(
//       imageQuality: 80, // Adjust the image quality as desired
//     );
//     setState(() {
//       if (images != null) {
//         uploadedImageList.addAll(images.map((image) => image.path));
//       }
//     });
//   }
//
//   Future<void> getgalleryVideo() async {
//     var videos = await _imagePicker.pickVideo(
//       source: ImageSource.gallery, // Adjust the image quality as desired
//     );
//     setState(() {
//       if (videos != null) {
//         uploadedImageList.add(videos.path);
//       }
//     });
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
// //---filter
//   init() async {
//     setStatusBarColor(scaffoldBgColor, statusBarIconBrightness: Brightness.light);
//     imageStatus.add("Gallery");
//     imageStatus.add("Server");
//     selectIndex = 0;
//     _tabController = new TabController(length: 2, vsync: this);
//     await fetchmedia().then((value){
//       if(value.results!.length > 0){
//         setState(() {
//           List<String> imglist = [];
//           List<String> vidlist = [];
//           value.results!.forEach((data) {
//             if(data.website_media.validate().contains('.mp4') || data.website_media.validate().contains('.MP4') || data.website_media.validate().contains('.MOV') || data.website_media.validate().contains('.mov')){
//               print("video");
//               String url = data.website_media.validate().toString().replaceFirst("http://","https://");
//               vidlist.add(url + "####@@@@####SB####@@@@####" + data.block_name.validate().toString() + "####@@@@####SB####@@@@####" + data.block_id.validate().toString() + "####@@@@####SB####@@@@####" + data.factory_product_name.validate().toString());
//             }else if(data.website_media.validate().contains('.jpeg') || data.website_media.validate().contains('.jpg') || data.website_media.validate().contains('.png')){
//               String url = data.website_media.validate().toString().replaceFirst("http://","https://");
//               imglist.add(url + "####@@@@####SB####@@@@####" + data.block_name.validate().toString() + "####@@@@####SB####@@@@####" + data.block_id.validate().toString()  + "####@@@@####SB####@@@@####" + data.factory_product_name.validate().toString());
//             }
//           });
//           imageList = imglist;
//           videoList = vidlist;
//           nextUrl = value.nexturl.validate();
//           print("imageList: $imageList");
//         });
//       }else{
//         setState(() {
//           videoList = [];
//           imageList = [];
//           nextUrl = '';
//         });
//       }
//     }).catchError((e) {
//       setState(() {});
//       log(e.toString());
//     });
//   }
//
//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }
//
//   @override
//   void dispose() {
//     setStatusBarColor(scaffoldBgColor,
//       statusBarIconBrightness: Brightness.light,
//     );
//     super.dispose();
//   }
//
//   addblockformData() async {
//     if(!widget.form_type.isEmptyOrNull && !widget.block_name.isEmptyOrNull && !widget.product_name.isEmptyOrNull && !widget.category_name.isEmptyOrNull && !widget.slab_type_name.isEmptyOrNull && !widget.slab_height.isEmptyOrNull && !widget.slab_length.isEmptyOrNull && !widget.slab_thickness.isEmptyOrNull && !widget.total_slabs.isEmptyOrNull) {
//       setState(() {
//         isLoading = true;
//       });
//       Map<String, dynamic> request = {
//         "user_id": "${getIntAsync(USER_ID)}",
//         "block_name": widget.block_name.toString(),
//         "product_name": widget.product_name.toString(),
//         "category_name": widget.category_name.toString(),
//         "form_type": widget.form_type.toString(),
//         "slab_type_name": widget.slab_type_name.toString(),
//         "slab_height": widget.slab_height.toString(),
//         "slab_length": widget.slab_length.toString(),
//         "slab_thickness": widget.slab_thickness.toString(),
//         "total_slabs": widget.total_slabs.toString(),
//       };
//       print("Media List: $mediaImageList");
//       print("Image List: $imagesList");
//       addBlockForm(request, mediaImageList,  file: imagesList).then((value) {
//
//       }).whenComplete(() async {
//         print("jj");
//         await fetchblocklistdata();
//         setState(() {
//           isLoading = false;
//         });
//       });
//
//       setState(() {
//         isLoading = false;
//       });
//     }else{
//       toast("Empty data found");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   fetchblocklistdata() async{
//     setState(() {
//       isloadingblocklist = true;
//     });
//     fetchblockform().then((value){
//       if(value.status == true){
//         setValue(BLOCK_FORM_LIST_LAST_ID, value.last_id);
//         if(value.blockFormData != null){
//           if(value.blockFormData!.length > 0){
//             List<BlockFormData>blockFormData = [];
//             value.blockFormData!.forEach((element) {
//               blockFormData.add(BlockFormData(
//                 id: element.id,
//                 block_name: element.block_name,
//                 product_name: element.product_name,
//                 category_name: element.category_name,
//                 form_type: element.form_type,
//                 slab_type_name: element.slab_type_name,
//                 slab_height: element.slab_height,
//                 slab_length: element.slab_length,
//                 slab_thickness: element.slab_thickness,
//                 total_slabs: element.total_slabs,
//                 form_status: element.form_status,
//                 images: element.images == null ? [] : element.images!.toList(),
//               ));
//             });
//             setValue(BLOCK_FORM_LIST,jsonEncode(blockFormData));
//             print("BLOCK_FORM_LIST Update: ${getStringAsync(BLOCK_FORM_LIST)}");
//             SBTeamDashboard(runHomeApi: false, isfilter: false).launch(context, isNewTask: true);
//           }
//         }
//       }else{
//         setState(() {
//           isloadingblocklist = false;
//         });
//       }
//     }).catchError((e){
//       print(e.toString());
//       setState(() {
//         isloadingblocklist = false;
//       });
//     });
//   }
//
//   Widget buildGridView() {
//     return GridView.count(
//       crossAxisCount: 1,
//       children: List.generate(uploadedImageList.length, (index) {
//         String asset = uploadedImageList[index];
//         return GestureDetector(
//           onLongPress: () {
//             print('Long Press Begin');
//             setState(() {
//               is_gallary_image_long_press = true;
//               _gallary_image = asset;
//             });
//           },
//           onLongPressEnd: (details) {
//             print('Long Press End');
//             setState(() {
//               is_gallary_image_long_press = false;
//               _gallary_image = asset;
//             });
//           },
//           onDoubleTap: (){
//             print('select image upload');
//             print(uploadedImageList);
//             setState(() {
//               _is_select_gallary_image = true;
//               _is_select_image = asset.toString();
//               imagesList.add(asset.toString());
//               print(asset.toString());
//               print(imagesList);
//               print(checkIfImageAdded(asset.toString()));
//             });
//           },
//           onTap: (){
//
//           },
//           child: (_is_select_gallary_image == true && checkIfImageAdded(asset.validate()) == true)
//               ? Stack(
//             children: <Widget>[
//               ColorFiltered(
//                 colorFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
//                 child: GestureDetector(
//                   onLongPress: () {
//                     print('Long Press Begin');
//                     setState(() {
//                       is_long_press = true;
//                       _image = asset.validate();
//                     });
//                   },
//                   onLongPressEnd: (details) {
//                     print('Long Press End');
//                     setState(() {
//                       is_long_press = false;
//                       _image = asset.validate();
//                     });
//                   },
//                   onDoubleTap: (){
//                     print('selectkk');
//                     setState(() {
//                       // is_select = false;
//                       _is_select_image = asset.validate();
//                       imagesList.remove(asset.validate());
//                       print(imagesList);
//                     });
//                   },
//                   child: asset.toString().contains('.mp4') || asset.toString().contains('.MP4') || asset.toString().contains('.mov') || asset.toString().contains('.MOV')
//                       ? CachedVideoWidget(
//                     url: asset.toString(),
//                     height:MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     fit: BoxFit.cover,
//                     radius: 10,
//                   ).cornerRadiusWithClipRRect(10).paddingAll(2)
//                       : CachedImageWidget(
//                     url: asset.toString(),
//                     height:MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     fit: BoxFit.cover,
//                     radius: 10,
//                   ).cornerRadiusWithClipRRect(10).paddingAll(2),
//                 ),
//               ),
//               Positioned(
//                 bottom: 15, right: 5, //give the values according to your requirement
//                 child: TextButton(
//                   style: TextButton.styleFrom(
//                     backgroundColor: kPrimaryColor,
//                     shape: CircleBorder(),
//                   ),
//                   child: Icon(
//                     Icons.check,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {},
//                 ),
//               ),
//             ],
//           ).cornerRadiusWithClipRRect(10).paddingAll(2)
//               : asset.toString().contains('.mp4') || asset.toString().contains('.MP4') || asset.toString().contains('.mov') || asset.toString().contains('.MOV')
//               ? CachedVideoWidget(
//             url: asset.toString(),
//             height:MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             fit: BoxFit.cover,
//             radius: 10,
//           ).cornerRadiusWithClipRRect(10).paddingAll(2)
//               : CachedImageWidget(
//             url: asset.toString(),
//             height:MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             fit: BoxFit.cover,
//             radius: 10,
//           ).cornerRadiusWithClipRRect(10).paddingAll(2),
//
//         );
//       }
//       ),
//     ).paddingAll(16);
//   }
//
//   Widget serverGridView() {
//     return Column(
//       children: [
//         TabBar(
//           unselectedLabelColor: Theme.of(context).iconTheme.color,
//           labelColor: Theme.of(context).iconTheme.color,
//           indicatorColor: Theme.of(context).iconTheme.color,
//           tabs: const [
//             Tab(
//               text: 'Images',
//             ),
//             Tab(
//               text: 'Video',
//             ),
//           ],
//           controller: _tabController,
//           indicatorSize: TabBarIndicatorSize.tab,
//         ),
//         Expanded(
//           child: TabBarView(
//             controller: _tabController,
//             children: [
//               serverGridViewImages(),
//               serverGridViewVideo()
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget serverGridViewImages() {
//     return GridView.count(
//       crossAxisCount: 2,
//       children: List.generate(imageList.length, (index){
//         return _imageitem(
//           media: imageList[index],
//         );
//       },
//       ),
//     ).visible(
//       imageList.length > 0,
//       defaultWidget: NoDataFoundWidget(iconSize: 120).center(),
//     ).paddingAll(16);
//   }
//
//   Widget serverGridViewVideo() {
//     return GridView.count(
//       crossAxisCount: 1,
//       children: List.generate(videoList.length, (index){
//         return _videoitem(
//           media: videoList[index],
//         );
//       },
//       ),
//     ).visible(
//       videoList.length > 0,
//       defaultWidget: NoDataFoundWidget(iconSize: 120).center(),
//     ).paddingAll(16);
//   }
//
//   bool checkIfMediaAdded(String? mediaUrl){
//     if(mediaImageList.isNotEmpty){
//       for(var url in mediaImageList){
//         if(url == mediaUrl){
//           return true;
//         }
//       }
//     }
//     return false;
//   }
//
//   bool checkIfImageAdded(String? imageUrl){
//     if(imagesList.isNotEmpty){
//       for(var url in imagesList){
//         if(url == imageUrl){
//           return true;
//         }
//       }
//     }
//     return false;
//   }
//
//   _imageitem({ String? media }) {
//     var imageurl = media.validate().split("####@@@@####SB####@@@@####")[0];
//     var blockname = media.validate().split("####@@@@####SB####@@@@####")[1];
//     var blockid = media.validate().split("####@@@@####SB####@@@@####")[2];
//     var factoryproduct = media.validate().split("####@@@@####SB####@@@@####")[3];
//     // print(blockname);
//     // print(blockid);
//     // print(factoryproduct);
//     return GestureDetector(
//         onLongPress: () {
//           print('Long Press Begin');
//           setState(() {
//             is_long_press = true;
//             _image = imageurl;
//           });
//         },
//         onLongPressEnd: (details) {
//           print('Long Press End');
//           setState(() {
//             is_long_press = false;
//             _image = imageurl;
//           });
//         },
//         onDoubleTap: (){
//           print('select image server');
//           setState(() {
//             is_select = true;
//             _is_select_image = imageurl;
//             mediaImageList.add(imageurl);
//             print(mediaImageList);
//           });
//         },
//         onTap: (){
//           Navigator.push(context, MaterialPageRoute(builder: (_) {
//             return DetailPhotoViewScreen(tag: "Image", url: imageurl.validate());
//           }));
//         },
//         child: (is_select == true && checkIfMediaAdded(imageurl.validate()) == true)
//             ? Stack(
//           children: <Widget>[
//             ColorFiltered(
//               colorFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
//               child: GestureDetector(
//                 onLongPress: () {
//                   print('Long Press Begin');
//                   setState(() {
//                     is_long_press = true;
//                     _image = imageurl.validate();
//                   });
//                 },
//                 onLongPressEnd: (details) {
//                   print('Long Press End');
//                   setState(() {
//                     is_long_press = false;
//                     _image = imageurl.validate();
//                   });
//                 },
//                 onDoubleTap: (){
//                   print('select');
//                   setState(() {
//                     // is_select = false;
//                     _is_select_image = imageurl.validate();
//                     mediaImageList.remove(imageurl.validate());
//                   });
//                 },
//                 child: Card(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(child: CachedImageWidget(
//                               url: imageurl.validate(),
//                               height:120,
//                               width:170,
//                               fit: BoxFit.cover,
//                               radius: 10,
//                             ).cornerRadiusWithClipRRect(10).paddingAll(2))
//                           ],
//                         ),
//                         if(blockid != '')
//                           Row(
//                             children: [
//                               Text(
//                                 "${blockid}",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: kTextColor,
//                                 ),
//                               ).paddingOnly(left: 5, right: 5)
//                             ],
//                           ),
//                         if(blockname != '')
//                           Row(
//                             children: [
//                               Text(
//                                 "${blockname}",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: kTextColor,
//                                 ),
//                               ).paddingOnly(left: 5, right: 5),
//                             ],
//                           ),
//                         if(factoryproduct != '')
//                           Row(
//                             children: [
//                               Text(
//                                 "${factoryproduct}",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: kTextColor,
//                                 ),
//                               ).paddingOnly(left: 5, right: 5),
//                             ],
//                           )
//                       ],
//                     )
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 15, right: 5, //give the values according to your requirement
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: kPrimaryColor,
//                   shape: CircleBorder(),
//                 ),
//                 child: Icon(
//                   Icons.check,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {},
//               ),
//             ),
//           ],
//         ).cornerRadiusWithClipRRect(10).paddingAll(2)
//             : Card(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 0,
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(child: CachedImageWidget(
//                       url: imageurl.validate(),
//                       height:110,
//                       width:170,
//                       fit: BoxFit.cover,
//                       radius: 10,
//                     ).cornerRadiusWithClipRRect(10).paddingAll(2))
//                   ],
//                 ),
//                 if(blockid != '')
//                   Row(
//                     children: [
//                       Text(
//                         "${blockid}",
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: kTextColor,
//                         ),
//                       ).paddingOnly(left: 5, right: 5)
//                     ],
//                   ),
//                 if(blockname != '')
//                   Row(
//                     children: [
//                       Text(
//                         "${blockname}",
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: kTextColor,
//                         ),
//                       ).paddingOnly(left: 5, right: 5),
//                     ],
//                   ),
//                 if(factoryproduct != '')
//                   Row(
//                     children: [
//                       Text(
//                         "${factoryproduct}",
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: kTextColor,
//                         ),
//                       ).paddingOnly(left: 5, right: 5),
//                     ],
//                   )
//               ],
//             )
//         )
//     );
//   }
//
//   _videoitem({ String? media }) {
//     var videourl = media.validate().split("####@@@@####SB####@@@@####")[0];
//     var blockname = media.validate().split("####@@@@####SB####@@@@####")[1];
//     var blockid = media.validate().split("####@@@@####SB####@@@@####")[2];
//     var factoryproduct = media.validate().split("####@@@@####SB####@@@@####")[3];
//     return GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onDoubleTap: (){
//           print('select video server');
//           setState(() {
//             is_select = true;
//             mediaImageList.add(videourl.validate());
//             print(mediaImageList);
//           });
//         },
//         child: (is_select == true && checkIfMediaAdded(videourl.validate()) == true)
//             ? Stack(
//           children: <Widget>[
//             ColorFiltered(
//               colorFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
//               child: GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onDoubleTap: (){
//                   print('select remove');
//                   setState(() {
//                     mediaImageList.remove(videourl.validate());
//                   });
//                 },
//                 child: Card(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                     child: Column(
//                       children: [
//                         Row(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   height:280,
//                                   width: MediaQuery.of(context).size.width * 0.85,
//                                   child: CachedVideoWidget(
//                                     url: videourl.validate(),
//                                     height:280,
//                                     width: 300,
//                                     fit: BoxFit.cover,
//                                     radius: 10,
//                                   ).cornerRadiusWithClipRRect(10).paddingAll(2),
//                                 ),
//                               ),
//                             ]
//                         ),
//                         Spacer(),
//                         if(blockid != '')
//                           Row(
//                             children: [
//                               Text(
//                                 "${blockid}",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: kTextColor,
//                                 ),
//                               ).paddingOnly(left: 5, right: 5)
//                             ],
//                           ),
//                         if(blockname != '')
//                           Row(
//                             children: [
//                               Text(
//                                 "Block Name - ${blockname}",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: kTextColor,
//                                 ),
//                               ).paddingOnly(left: 5, right: 5),
//                             ],
//                           ),
//                         if(factoryproduct != '')
//                           Row(
//                             children: [
//                               Text(
//                                 "${factoryproduct}",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: kTextColor,
//                                 ),
//                               ).paddingOnly(left: 5, right: 5),
//                             ],
//                           ),
//                         Spacer(),
//
//                       ],
//                     )
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 15, right: 5, //give the values according to your requirement
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: kPrimaryColor,
//                   shape: CircleBorder(),
//                 ),
//                 child: Icon(
//                   Icons.check,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {},
//               ),
//             ),
//           ],
//         ).cornerRadiusWithClipRRect(10).paddingAll(2)
//             :  Card(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 0,
//             child: Column(
//               children: [
//                 Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height:280,
//                           width: MediaQuery.of(context).size.width * 0.85,
//                           child: CachedVideoWidget(
//                             url: videourl.validate(),
//                             height:280,
//                             width: 300,
//                             fit: BoxFit.cover,
//                             radius: 10,
//                           ).cornerRadiusWithClipRRect(10).paddingAll(2),
//                         ),
//                       ),
//                     ]
//                 ),
//                 Spacer(),
//                 if(blockid != '')
//                   Row(
//                     children: [
//                       Text(
//                         "${blockid}",
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: kTextColor,
//                         ),
//                       ).paddingOnly(left: 5, right: 5)
//                     ],
//                   ),
//                 if(blockname != '')
//                   Row(
//                     children: [
//                       Text(
//                         "${blockname}",
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: kTextColor,
//                         ),
//                       ).paddingOnly(left: 5, right: 5),
//                     ],
//                   ),
//                 if(factoryproduct != '')
//                   Row(
//                     children: [
//                       Text(
//                         "${factoryproduct}",
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: kTextColor,
//                         ),
//                       ).paddingOnly(left: 5, right: 5),
//                     ],
//                   ),
//                 Spacer(),
//               ],
//             )
//         )
//     );
//   }
//
//   Future refresh() async{
//     print(nextUrl);
//     if(nextUrl != '')
//     {
//       setState(() {
//         _isloading = true;
//       });
//       if(nextUrl.validate().contains('http://'))
//       {
//         nextUrl = nextUrl.validate().replaceAll('http://', 'https://');
//       }
//       await fetchmediafromnexturl(nextUrl).then((value){
//         if(value.results!.length > 0){
//           setState(() {
//             List<String> imglist = [];
//             List<String> vidlist = [];
//             value.results!.forEach((data) {
//               if(data.website_media.validate().contains('.mp4') || data.website_media.validate().contains('.MP4') || data.website_media.validate().contains('.MOV') || data.website_media.validate().contains('.mov')){
//                 String url = data.website_media.validate().toString().replaceFirst("http://","https://");
//                 vidlist.add(url + "####@@@@####SB####@@@@####" + data.block_name.validate().toString() + "####@@@@####SB####@@@@####" + data.block_id.validate().toString() + "####@@@@####SB####@@@@####" + data.factory_product_name.validate().toString() );
//               }else if(data.website_media.validate().contains('.jpeg') || data.website_media.validate().contains('.jpg') || data.website_media.validate().contains('.png')){
//                 String url = data.website_media.validate().toString().replaceFirst("http://","https://");
//                 imglist.add(url + "####@@@@####SB####@@@@####" + data.block_name.validate().toString() + "####@@@@####SB####@@@@####" + data.block_id.validate().toString() + "####@@@@####SB####@@@@####" + data.factory_product_name.validate().toString());
//               }
//             });
//             imageList.addAll(imglist);
//             print(imageList.length);
//             videoList.addAll(vidlist);
//             print(videoList.length);
//             nextUrl = value.nexturl.validate();
//           });
//         }
//       }).catchError((e) {
//         setState(() {});
//         log(e.toString());
//       });
//       setState(() {
//         _isloading = false;
//       });
//     }
//   }
//
//   Future filtermediadata(typeSelected, isEnquiry, productSelected, blockSelected) async {
//     hideKeyboard(context);
//     print("kkk");
//     print(typeSelected);
//     print(isEnquiry);
//     print(productSelected);
//     print(blockSelected);
//     await filtermedia(typeSelected, isEnquiry, productSelected, blockSelected).then((value) {
//       if(value.results != null){
//         if(value.results!.length > 0){
//           setState(() {
//             List<String> imglist = [];
//             List<String> vidlist = [];
//             value.results!.forEach((data) {
//               if(data.website_media.validate().contains('.mp4') || data.website_media.validate().contains('.MP4') || data.website_media.validate().contains('.mov') || data.website_media.validate().contains('.MOV')){
//                 String url = data.website_media.validate().toString().replaceFirst("http://","https://");
//                 vidlist.add(url + "####@@@@####SB####@@@@####" + data.block_name.validate().toString() + "####@@@@####SB####@@@@####" + data.block_id.validate().toString() + "####@@@@####SB####@@@@####" + data.factory_product_name.validate().toString());
//               }else if(data.website_media.validate().contains('.jpeg') || data.website_media.validate().contains('.jpg') || data.website_media.validate().contains('.png')){
//                 String url = data.website_media.validate().toString().replaceFirst("http://","https://");
//                 imglist.add(url + "####@@@@####SB####@@@@####" + data.block_name.validate().toString() + "####@@@@####SB####@@@@####" + data.block_id.validate().toString() + "####@@@@####SB####@@@@####" + data.factory_product_name.validate().toString());
//               }
//             });
//             imageList = imglist ;
//             print(imageList.length);
//             videoList = vidlist;
//             print(videoList.length);
//             nextUrl = value.nexturl.validate();
//           });
//         }
//       }
//     }).catchError((e) {
//       setState(() {});
//       log(e.toString());
//     });
//   }
//
//   void filterDialog() {
//     showInDialog(context, title: Text("Filter Media", style: boldTextStyle(), textAlign: TextAlign.justify), barrierColor: Colors.black45, backgroundColor: scaffoldBgColor,
//         builder: (context) {
//           return AddFilterDailog(filtermediadata : filtermediadata);
//         }
//     );
//   }
//
//   Future Refresh() async{
//     print(nextUrl);
//     if(nextUrl != '')
//     {
//       setState(() {
//         _isloading = true;
//       });
//       if(nextUrl.validate().contains('http://'))
//       {
//         nextUrl = nextUrl.validate().replaceAll('http://', 'https://');
//       }
//       await fetchmediafromnexturl(nextUrl).then((value){
//         if(value.results!.length > 0){
//           setState(() {
//             List<String> imglist = [];
//             List<String> vidlist = [];
//             value.results!.forEach((data) {
//               if(data.website_media.validate().contains('.mp4') || data.website_media.validate().contains('.MP4') || data.website_media.validate().contains('.mov') || data.website_media.validate().contains('.MOV')){
//                 String url = data.website_media.validate().toString().replaceFirst("http://","https://");
//                 vidlist.add(url + "####@@@@####SB####@@@@####" + data.block_name.validate().toString() + "####@@@@####SB####@@@@####" + data.block_id.validate().toString() + "####@@@@####SB####@@@@####" + data.factory_product_name.validate().toString() );
//               }else if(data.website_media.validate().contains('.jpeg') || data.website_media.validate().contains('.jpg') || data.website_media.validate().contains('.png')){
//                 String url = data.website_media.validate().toString().replaceFirst("http://","https://");
//                 imglist.add(url + "####@@@@####SB####@@@@####" + data.block_name.validate().toString() + "####@@@@####SB####@@@@####" + data.block_id.validate().toString() + "####@@@@####SB####@@@@####" + data.factory_product_name.validate().toString() );
//               }
//             });
//             List<int> test = [1, 2, 3, 4, 5];
//             List<int> dd = [];
//             dd.addAll(test);
//             print("LIST: ${dd.reversed}");
//             imageList.addAll(imglist);
//             imageList.reversed;
//             print(imageList.length);
//             videoList.addAll(vidlist);
//             videoList.reversed;
//             print(videoList.length);
//             nextUrl = value.nexturl.validate();
//           });
//         }
//       }).catchError((e) {
//         setState(() {});
//         log(e.toString());
//       });
//       setState(() {
//         _isloading = false;
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: appImageBar(context, name: 'Upload Images', filter: filterDialog, reload: refresh ),
//         body: isLoading == true
//             ? const Center(
//             child: SizedBox(
//               height: 20,
//               width: 20,
//               child: CircularProgressIndicator(
//                 color: kPrimaryColor,
//                 strokeWidth: 2,
//               ),
//             )
//         )
//             : LiquidPullToRefresh(
//           color: Colors.white,
//           height: 100,
//           animSpeedFactor: 2,
//           backgroundColor: Colors.orange,
//           showChildOpacityTransition: true,
//           onRefresh: Refresh,
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 HorizontalList(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: imageStatus.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       alignment: Alignment.topLeft,
//                       padding: EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
//                       margin: EdgeInsets.only(left: 0, right: 8, top: 4, bottom: 4),
//                       decoration: BoxDecoration(
//                         color: selectIndex == index
//                             ? kPrimaryColor
//                             : scaffoldBgColor,
//                         borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
//                       ),
//                       child: FittedBox(
//                         child: Text(
//                           imageStatus[index],
//                           style: primaryTextStyle(size: 14, color: selectIndex == index ? white : Theme.of(context).iconTheme.color),
//                           textAlign: TextAlign.center,
//                         ).paddingSymmetric(horizontal: 25, vertical: 2),
//                       ),
//                     ).onTap(
//                           () {
//                         setState(() {
//                           selectIndex = index;
//                         });
//                       },
//                     );
//                   },
//                 ),
//                 10.height,
//                 if (is_long_press) ...[
//                   BackdropFilter(
//                     filter: ImageFilter.blur(
//                       sigmaX: 5.0,
//                       sigmaY: 5.0,
//                     ),
//                     child: Container(
//                       color: Colors.white.withOpacity(0.6),
//                     ),
//                   ),
//                   Container(
//                     child: Center(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Image.network(
//                           _image,
//                           height: 300,
//                           width: MediaQuery.of(context).size.width,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                 if (is_gallary_image_long_press) ...[
//                   BackdropFilter(
//                     filter: ImageFilter.blur(
//                       sigmaX: 5.0,
//                       sigmaY: 5.0,
//                     ),
//                     child: Container(
//                       color: Colors.white.withOpacity(0.6),
//                     ),
//                   ),
//                   Container(
//                     child: Center(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: CachedImageWidget(
//                           url: _gallary_image.toString(),
//                           height: 300,
//                           width: 300,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                 Expanded(
//                   child: Container(
//                     height: MediaQuery.of(context).size.height,
//                     child: (selectIndex == 0)
//                         ? buildGridView()
//                         : (_isloading == true)
//                         ? const Center(
//                         child: SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             color: kPrimaryColor,
//                             strokeWidth: 2,
//                           ),
//                         )
//                     )
//                         :serverGridView(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: (selectIndex == 0)
//             ? (selectIndex == 0 && imagesList.isEmpty == false)
//             ? AddFloatingButton(
//           icon: FontAwesomeIcons.check,
//           onTap: () async{
//             addblockformData();
//             imageList = [];
//           },
//         )
//             : AddFloatingButton(
//           icon: FontAwesomeIcons.upload,
//           onTap: () async{
//             showModalBottomSheet(
//                 context: context,
//                 builder:(BuildContext context){
//                   return Container(
//                     height: 150,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Row(
//                         children: [
//                           MaterialButton(
//                             onPressed: () async {
//                               print("camera");
//                               PermissionStatus cameraStatus = await Permission.camera.request();
//                               if(cameraStatus == PermissionStatus.granted){
//                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission Granted")));
//                               }
//                               // if(cameraStatus == PermissionStatus.denied){
//                               //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You need to provide camera permission")));
//                               // }
//                               // if(cameraStatus == PermissionStatus.permanentlyDenied){
//                               //   openAppSettings();
//                               // }
//                               getcam();
//                             },
//                             color: Colors.orange.shade700,
//                             textColor: Colors.white,
//                             child: Icon(
//                               Icons.camera_alt,
//                               size: 24,
//                             ),
//                             padding: EdgeInsets.all(16),
//                             shape: CircleBorder(),
//                           ),
//                           Spacer(),
//                           MaterialButton(
//                             onPressed: getgalleryVideo,
//                             color: Colors.orange.shade700,
//                             textColor: Colors.white,
//                             child: Icon(
//                               Icons.video_camera_back,
//                               size: 24,
//                             ),
//                             padding: EdgeInsets.all(16),
//                             shape: CircleBorder(),
//                           ),
//                           Spacer(),
//                           MaterialButton(
//                             onPressed: getgallery,
//                             // _pickImagesFromGallery,
//                             color: Colors.orange.shade700,
//                             textColor: Colors.white,
//                             child: Icon(
//                               Icons.photo,
//                               size: 24,
//                             ),
//                             padding: EdgeInsets.all(16),
//                             shape: CircleBorder(),
//                           ),
//
//                         ],
//                       ),
//                     ),
//
//                   );
//
//                 }
//             );
//           },
//         )
//             : (mediaImageList.length > 0)
//             ? AddFloatingButton(
//           icon: FontAwesomeIcons.check,
//           onTap: () async{
//             print("i");
//             await addblockformData();
//             mediaImageList = [];
//           },
//         )
//             : Container(),
//
//       ),
//     );
//   }
//
//
// }