import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/blockform.dart';
import 'package:stoneindia/screen/SBTeam/sbteamdashboard.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/addfilterdialog.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:stoneindia/widget/cachedimage.dart';
import 'package:stoneindia/widget/cachedvideo.dart';
import 'package:stoneindia/widget/detailsphotoview.dart';
import 'package:stoneindia/widget/nodatafound.dart';

class EditImageBlockFormScreen extends StatefulWidget {

  const EditImageBlockFormScreen({Key? key,
    this.block_id,
    this.block_name,
    this.product_name,
    this.category_name,
    this.form_type,
    this.slab_type_name,
    this.slab_height,
    this.slab_length,
    this.slab_thickness,
    this.total_slabs,
    this.blockform_images,
  }) : super(key: key);

  final int? block_id;
  final String? block_name;
  final String? product_name;
  final String? category_name;
  final String? form_type;
  final String? slab_type_name;
  final String? slab_height;
  final String? slab_length;
  final String? slab_thickness;
  final String? total_slabs;
  final List<BlockImages>? blockform_images;

  @override
  _EditImageBlockFormScreenState createState() => _EditImageBlockFormScreenState();
}

class _EditImageBlockFormScreenState extends State<EditImageBlockFormScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  List<String> imagesList = [];
  List<String> uploadedImageList = [];
  List<String> uploadedMediaList = [];
  bool is_uploaded_media_select = false;
  final String _error = 'No Error Detected';
  List<String> imageStatus = [];
  int selectIndex = -1;
  bool is_long_press = false;
  bool is_long_uploaded_press = false;
  String _image = "";
  String _uploaded = "";
  bool is_select = false;
  String _is_select_image = "";
  String _is_select_uploaded_image = "";
  bool is_gallary_image_long_press = false;
  bool is_uploaded_image_long_press = false;
  bool _is_select_gallary_image = false;
  String _gallary_image = '';
  String _uploaded_image = '';
  List<String> mediaImageList = [];
  List<String> uploadedList = [];
  List<String> videoList = [];
  List<String> imageList = [];
  int? last_id;
  bool _isloading = false;
  bool showSpinner = false;
  bool isloadingblocklist = false;
  bool isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();
  var productSelectedData;
  var blockSelectedData;
  var categorySelectedData;
  var slabSelectedData;
  var isEnquiryData;

  Future<void> getcam() async {
    var img = await _imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      if (img != null) {
        uploadedImageList.add(img.path);
      }
    });
  }

  Future<void> getgallery() async {
    var images = await _imagePicker.pickMultiImage(
      imageQuality: 80, // Adjust the image quality as desired
    );
    setState(() {
      uploadedImageList.addAll(images.map((image) => image.path));
        });
  }

  Future<void> getgalleryVideo() async {
    var videos = await _imagePicker.pickVideo(
      source: ImageSource.gallery, // Adjust the image quality as desired
    );
    setState(() {
      if (videos != null) {
        uploadedImageList.add(videos.path);
      }
    });
  }



  @override
  void initState() {
    super.initState();
    init();
  }
//---filter
  init() async {
    setStatusBarColor(scaffoldBgColor, statusBarIconBrightness: Brightness.light);
    imageStatus.add("My Media");
    imageStatus.add("Gallery");
    imageStatus.add("Server");
    selectIndex = 0;
    _tabController = TabController(length: 2, vsync: this);
    await filterservermedia(null, categorySelectedData, isEnquiryData, productSelectedData, blockSelectedData, slabSelectedData).then((value){
      if(value.data!.isNotEmpty){
        setState(() {
          List<String> imglist = [];
          List<String> vidlist = [];
          for (var data in value.data!) {
            if(data.website_media.validate().contains('.mp4') || data.website_media.validate().contains('.MP4') || data.website_media.validate().contains('.MOV') || data.website_media.validate().contains('.mov')){
              print("video");
              String url = data.website_media.validate().toString().replaceFirst("http://","https://");
              vidlist.add("$url####@@@@####SB####@@@@####${data.block_name.validate()}####@@@@####SB####@@@@####${data.block_id.validate()}####@@@@####SB####@@@@####${data.product_name.validate()}");
            }else if(data.website_media.validate().contains('.jpeg') || data.website_media.validate().contains('.jpg') || data.website_media.validate().contains('.png')){
              String url = data.website_media.validate().toString().replaceFirst("http://","https://");
              imglist.add("$url####@@@@####SB####@@@@####${data.block_name.validate()}####@@@@####SB####@@@@####${data.block_id.validate()}####@@@@####SB####@@@@####${data.product_name.validate()}");
            }
          }
          imageList = imglist;
          videoList = vidlist;
          last_id = value.last_id;
          print("imageList: $imageList");
        });
      }else{
        setState(() {
          videoList = [];
          imageList = [];
          last_id = null;
        });
      }
    }).catchError((e) {
      setState(() {});
      log(e.toString());
    });
    if(widget.blockform_images != null){
      if(widget.blockform_images!.isNotEmpty){
        for (var element in widget.blockform_images!) {
          uploadedMediaList.add(element.image.toString());
          uploadedList.add(element.image.toString());
          is_uploaded_media_select = true;
        }
      }
    }
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

  editblockformData() async {
    toast("Update in progress..");
    mediaImageList = mediaImageList + uploadedList;
    print("Media List: $mediaImageList");
    print("File List: $imagesList");
    if(!widget.form_type.isEmptyOrNull && !widget.block_name.isEmptyOrNull && !widget.product_name.isEmptyOrNull && !widget.category_name.isEmptyOrNull && !widget.slab_type_name.isEmptyOrNull && !widget.slab_height.isEmptyOrNull && !widget.slab_length.isEmptyOrNull && !widget.slab_thickness.isEmptyOrNull && !widget.total_slabs.isEmptyOrNull) {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> request = {
        "block_id": "${widget.block_id}",
        "user_id": "${getIntAsync(USER_ID)}",
        "block_name": widget.block_name.toString(),
        "product_name": widget.product_name.toString(),
        "category_name": widget.category_name.toString(),
        "form_type": widget.form_type.toString(),
        "slab_type_name": widget.slab_type_name.toString(),
        "slab_height": widget.slab_height.toString(),
        "slab_length": widget.slab_length.toString(),
        "slab_thickness": widget.slab_thickness.toString(),
        "total_slabs": widget.total_slabs.toString(),
      };
      print("Media List: $mediaImageList");
      print("Image List: $imagesList");
      editBlockForm(request, mediaImageList,  file: imagesList).then((value) {

      }).whenComplete(() async {
        print("jj");
        await fetchblocklistdata();
        setState(() {
          isLoading = false;
        });
      });

      setState(() {
        isLoading = false;
      });
    }else{
      toast("Empty data found");
      setState(() {
        isLoading = false;
      });
    }
  }

  fetchblocklistdata() async{
    setState(() {
      isloadingblocklist = true;
    });
    fetchblockform().then((value){
      if(value.status == true){
        setValue(BLOCK_FORM_LIST_LAST_ID, value.last_id);
        if(value.blockFormData != null){
          if(value.blockFormData!.isNotEmpty){
            List<BlockFormData>blockFormData = [];
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
            setValue(BLOCK_FORM_LIST,jsonEncode(blockFormData));
            print("BLOCK_FORM_LIST Update: ${getStringAsync(BLOCK_FORM_LIST)}");
            const SBTeamDashboard(runHomeApi: false, isfilter: false).launch(context, isNewTask: true);
          }
        }
      }else{
        setState(() {
          isloadingblocklist = false;
        });
      }
    }).catchError((e){
      print(e.toString());
      setState(() {
        isloadingblocklist = false;
      });
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(uploadedImageList.length, (index) {
        String asset = uploadedImageList[index];
        return GestureDetector(
          onLongPress: () {
            print('Long Press Begin');
            setState(() {
              is_gallary_image_long_press = true;
              _gallary_image = asset;
            });
          },
          onLongPressEnd: (details) {
            print('Long Press End');
            setState(() {
              is_gallary_image_long_press = false;
              _gallary_image = asset;
            });
          },
          onDoubleTap: (){
            print('select image upload');
            print(uploadedImageList);
            setState(() {
              _is_select_gallary_image = true;
              _is_select_image = asset.toString();
              imagesList.add(asset.toString());
              print(asset.toString());
              print(imagesList);
              print(checkIfImageAdded(asset.toString()));
            });
          },
          onTap: (){

          },
          child: (_is_select_gallary_image == true && checkIfImageAdded(asset.validate()) == true)
              ? Stack(
            children: <Widget>[
              ColorFiltered(
                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
                child: GestureDetector(
                  onLongPress: () {
                    print('Long Press Begin');
                    setState(() {
                      is_long_press = true;
                      _image = asset.validate();
                    });
                  },
                  onLongPressEnd: (details) {
                    print('Long Press End');
                    setState(() {
                      is_long_press = false;
                      _image = asset.validate();
                    });
                  },
                  onDoubleTap: (){
                    print('selectkk');
                    setState(() {
                      // is_select = false;
                      _is_select_image = asset.validate();
                      imagesList.remove(asset.validate());
                      print(imagesList);
                    });
                  },
                  child: asset.toString().contains('.mp4') || asset.toString().contains('.MP4') || asset.toString().contains('.mov') || asset.toString().contains('.MOV')
                      ? CachedVideoWidget(
                    url: asset.toString(),
                    height:MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    radius: 10,
                  ).cornerRadiusWithClipRRect(10).paddingAll(2)
                      : CachedImageWidget(
                    url: asset.toString(),
                    height:MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    radius: 10,
                  ).cornerRadiusWithClipRRect(10).paddingAll(2),
                ),
              ),
              Positioned(
                bottom: 15, right: 20, //give the values according to your requirement
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: TextButton(
                    child: const Icon(
                      Icons.check,
                      color: Colors.orange,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ).cornerRadiusWithClipRRect(10).paddingAll(2)
              : asset.toString().contains('.mp4') || asset.toString().contains('.MP4') || asset.toString().contains('.mov') || asset.toString().contains('.MOV')
              ? CachedVideoWidget(
            url: asset.toString(),
            height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            radius: 10,
          ).cornerRadiusWithClipRRect(10).paddingAll(2)
              : CachedImageWidget(
            url: asset.toString(),
            height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            radius: 10,
          ).cornerRadiusWithClipRRect(10).paddingAll(2),

        );
      }
      ),
    ).paddingAll(16);
  }


  Widget uploadedMediaView() {
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(uploadedMediaList.length, (index) {
        String asset = uploadedMediaList[index];
        return GestureDetector(
          onLongPress: () {
            print('Long Press Begin');
            setState(() {
              is_uploaded_image_long_press = true;
              _uploaded_image = asset;
            });
          },
          onLongPressEnd: (details) {
            print('Long Press End');
            setState(() {
              is_uploaded_image_long_press = false;
              _uploaded_image = asset;
            });
          },
          onDoubleTap: (){
            print('select uploaded image upload');
            print(uploadedMediaList);
            setState(() {
              is_uploaded_media_select = true;
              _is_select_uploaded_image = asset.toString();
              uploadedList.add(asset.toString());
              print(asset.toString());
              print(uploadedList);
              print(checkIfUploadedImageAdded(asset.toString()));
            });
          },
          onTap: (){

          },
          child: (is_uploaded_media_select == true && checkIfUploadedImageAdded(asset.validate()) == true)
              ? Stack(
            children: <Widget>[
              ColorFiltered(
                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
                child: GestureDetector(
                  onLongPress: () {
                    print('Long Press Begin');
                    setState(() {
                      is_long_uploaded_press = true;
                      _uploaded = asset.validate();
                    });
                  },
                  onLongPressEnd: (details) {
                    print('Long Press End');
                    setState(() {
                      is_long_uploaded_press = false;
                      _uploaded = asset.validate();
                    });
                  },
                  onDoubleTap: (){
                    print('selectkk uploaded');
                    setState(() {
                      // is_select = false;
                      _is_select_uploaded_image = asset.validate();
                      uploadedList.remove(asset.validate());
                      print(uploadedList);
                    });
                  },
                  child: asset.toString().contains('.mp4') || asset.toString().contains('.MP4') || asset.toString().contains('.mov') || asset.toString().contains('.MOV')
                      ? CachedVideoWidget(
                    url: asset.toString(),
                    height:MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    radius: 10,
                  ).cornerRadiusWithClipRRect(10).paddingAll(2)
                      : CachedImageWidget(
                    url: asset.toString(),
                    height:MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    radius: 10,
                  ).cornerRadiusWithClipRRect(10).paddingAll(2),
                ),
              ),
              Positioned(
                bottom: 15, right: 20, //give the values according to your requirement
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: TextButton(
                    child: const Icon(
                      Icons.check,
                      color: Colors.orange,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ).cornerRadiusWithClipRRect(10).paddingAll(2)
              : asset.toString().contains('.mp4') || asset.toString().contains('.MP4') || asset.toString().contains('.mov') || asset.toString().contains('.MOV')
              ? CachedVideoWidget(
            url: asset.toString(),
            height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            radius: 10,
          ).cornerRadiusWithClipRRect(10).paddingAll(2)
              : CachedImageWidget(
            url: asset.toString(),
            height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            radius: 10,
          ).cornerRadiusWithClipRRect(10).paddingAll(2),

        );
      }
      ),
    ).paddingAll(16);
  }

  Widget serverGridView() {
    return Column(
      children: [
        TabBar(
          unselectedLabelColor: Theme.of(context).iconTheme.color,
          labelColor: Theme.of(context).iconTheme.color,
          indicatorColor: Theme.of(context).iconTheme.color,
          tabs: const [
            Tab(
              text: 'Images',
            ),
            Tab(
              text: 'Video',
            ),
          ],
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              serverGridViewImages(),
              serverGridViewVideo()
            ],
          ),
        ),
      ],
    );
  }

  Widget serverGridViewImages() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(imageList.length, (index){
        return _imageitem(
          media: imageList[index],
        );
      },
      ),
    ).visible(
      imageList.isNotEmpty,
      defaultWidget: const NoDataFoundWidget(iconSize: 120).center(),
    );
  }

  Widget serverGridViewVideo() {
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(videoList.length, (index){
        return _videoitem(
          media: videoList[index],
        );
      },
      ),
    ).visible(
      videoList.isNotEmpty,
      defaultWidget: const NoDataFoundWidget(iconSize: 120).center(),
    );
  }

  bool checkIfMediaAdded(String? mediaUrl){
    if(mediaImageList.isNotEmpty){
      for(var url in mediaImageList){
        if(url == mediaUrl){
          return true;
        }
      }
    }
    return false;
  }

  bool checkIfImageAdded(String? imageUrl){
    if(imagesList.isNotEmpty){
      for(var url in imagesList){
        if(url == imageUrl){
          return true;
        }
      }
    }
    return false;
  }

  bool checkIfUploadedImageAdded(String? imageUrl){
    if(uploadedList.isNotEmpty){
      for(var url in uploadedList){
        if(url == imageUrl){
          return true;
        }
      }
    }
    return false;
  }

  _imageitem({ String? media }) {
    var imageurl = media.validate().split("####@@@@####SB####@@@@####")[0];
    var blockname = media.validate().split("####@@@@####SB####@@@@####")[1];
    var blockid = media.validate().split("####@@@@####SB####@@@@####")[2];
    var factoryproduct = media.validate().split("####@@@@####SB####@@@@####")[3];
    // print(blockname);
    // print(blockid);
    // print(factoryproduct);
    print(imageurl);
    return GestureDetector(
        onLongPress: () {
          print('Long Press Begin');
          setState(() {
            is_long_press = true;
            _image = imageurl;
          });
        },
        onLongPressEnd: (details) {
          print('Long Press End');
          setState(() {
            is_long_press = false;
            _image = imageurl;
          });
        },
        onDoubleTap: (){
          print('select image server');
          setState(() {
            is_select = true;
            _is_select_image = imageurl;
            mediaImageList.add(imageurl);
            print(mediaImageList);
          });
        },
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailPhotoViewScreen(tag: "Image", url: imageurl.validate());
          }));
        },
        child: (is_select == true && checkIfMediaAdded(imageurl.validate()) == true)
            ? Stack(
          children: <Widget>[
            ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
              child: GestureDetector(
                onLongPress: () {
                  print('Long Press Begin');
                  setState(() {
                    is_long_press = true;
                    _image = imageurl.validate();
                  });
                },
                onLongPressEnd: (details) {
                  print('Long Press End');
                  setState(() {
                    is_long_press = false;
                    _image = imageurl.validate();
                  });
                },
                onDoubleTap: (){
                  print('select');
                  setState(() {
                    // is_select = false;
                    _is_select_image = imageurl.validate();
                    mediaImageList.remove(imageurl.validate());
                  });
                },
                child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: CachedImageWidget(
                              url: imageurl.validate(),
                              height:110,
                              width:170,
                              fit: BoxFit.cover,
                              radius: 10,
                            ).cornerRadiusWithClipRRect(10).paddingAll(2))
                          ],
                        ),
                        if(blockid != '')
                          Row(
                            children: [
                              Expanded(child: Text(
                                "Block Id - $blockid",
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kTextColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ).paddingOnly(left: 5, right: 5),
                              )
                            ],
                          ),
                        if(blockname != '')
                          Row(
                            children: [
                              Expanded(child: Text(
                                "Block Name - $blockname",
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kTextColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ).paddingOnly(left: 5, right: 5),)
                            ],
                          ),
                        if(factoryproduct != '')
                          Row(
                            children: [
                              Expanded(child:
                              Text(
                                "Product Name - $factoryproduct",
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kTextColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ).paddingOnly(left: 5, right: 5),
                              )
                            ],
                          ),
                      ],
                    )
                ),
              ),
            ),
            Positioned(
              bottom: 15, right: 20, //give the values according to your requirement
              child: SizedBox(
                height: 20,
                width: 20,
                child: TextButton(
                  child: const Icon(
                    Icons.check,
                    color: Colors.orange,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ).cornerRadiusWithClipRRect(10).paddingAll(2)
            : Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: CachedImageWidget(
                      url: imageurl.validate(),
                      height:110,
                      width:170,
                      fit: BoxFit.cover,
                      radius: 10,
                    ).cornerRadiusWithClipRRect(10).paddingAll(2))
                  ],
                ),
                if(blockid != '')
                  Row(
                    children: [
                      Expanded(child: Text(
                        "Block Id - $blockid",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          color: kTextColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ).paddingOnly(left: 5, right: 5),
                      )
                    ],
                  ),
                if(blockname != '')
                  Row(
                    children: [
                      Expanded(child: Text(
                        "Block Name - $blockname",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          color: kTextColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ).paddingOnly(left: 5, right: 5),)
                    ],
                  ),
                if(factoryproduct != '')
                  Row(
                    children: [
                      Expanded(child:
                      Text(
                        "Product Name - $factoryproduct",
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12,
                          color: kTextColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ).paddingOnly(left: 5, right: 5),
                      )
                    ],
                  )
              ],
            )
        )
    );
  }

  _videoitem({ String? media }) {
    var videourl = media.validate().split("####@@@@####SB####@@@@####")[0];
    var blockname = media.validate().split("####@@@@####SB####@@@@####")[1];
    var blockid = media.validate().split("####@@@@####SB####@@@@####")[2];
    var factoryproduct = media.validate().split("####@@@@####SB####@@@@####")[3];
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: (){
          print('select video server');
          setState(() {
            is_select = true;
            mediaImageList.add(videourl.validate());
            print(mediaImageList);
          });
        },
        child: (is_select == true && checkIfMediaAdded(videourl.validate()) == true)
            ? Stack(
          children: <Widget>[
            ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onDoubleTap: (){
                  print('select remove');
                  setState(() {
                    mediaImageList.remove(videourl.validate());
                  });
                },
                child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    child: Column(
                      children: [
                        Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height:280,
                                  width: MediaQuery.of(context).size.width * 0.85,
                                  child: CachedVideoWidget(
                                    url: videourl.validate(),
                                    height:280,
                                    width: 300,
                                    fit: BoxFit.cover,
                                    radius: 10,
                                  ).cornerRadiusWithClipRRect(10).paddingAll(2),
                                ),
                              ),
                            ]
                        ),
                        const Spacer(),
                        if(blockid != '')
                          Row(
                            children: [
                              Text(
                                "Block Id - $blockid",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: kTextColor,
                                ),
                              ).paddingOnly(left: 5, right: 5)
                            ],
                          ),
                        if(blockname != '')
                          Row(
                            children: [
                              Text(
                                "Block Name - $blockname",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: kTextColor,
                                ),
                              ).paddingOnly(left: 5, right: 5),
                            ],
                          ),
                        if(factoryproduct != '')
                          Row(
                            children: [
                              Text(
                                "Product Name - $factoryproduct",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: kTextColor,
                                ),
                              ).paddingOnly(left: 5, right: 5),
                            ],
                          ),
                        const Spacer(),

                      ],
                    )
                ),
              ),
            ),
            Positioned(
              bottom: 15, right: 20, //give the values according to your requirement
              child: SizedBox(
                height: 20,
                width: 20,
                child: TextButton(
                  child: const Icon(
                    Icons.check,
                    color: Colors.orange,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ).cornerRadiusWithClipRRect(10).paddingAll(2)
            :  Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            child: Column(
              children: [
                Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height:280,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: CachedVideoWidget(
                            url: videourl.validate(),
                            height:280,
                            width: 300,
                            fit: BoxFit.cover,
                            radius: 10,
                          ).cornerRadiusWithClipRRect(10).paddingAll(2),
                        ),
                      ),
                    ]
                ),
                const Spacer(),
                if(blockid != '')
                  Row(
                    children: [
                      Text(
                        "Block Id - $blockid",
                        style: const TextStyle(
                          fontSize: 14,
                          color: kTextColor,
                        ),
                      ).paddingOnly(left: 5, right: 5)
                    ],
                  ),
                if(blockname != '')
                  Row(
                    children: [
                      Text(
                        "Block Name - $blockname",
                        style: const TextStyle(
                          fontSize: 14,
                          color: kTextColor,
                        ),
                      ).paddingOnly(left: 5, right: 5),
                    ],
                  ),
                if(factoryproduct != '')
                  Row(
                    children: [
                      Text(
                        "Product Name - $factoryproduct",
                        style: const TextStyle(
                          fontSize: 14,
                          color: kTextColor,
                        ),
                      ).paddingOnly(left: 5, right: 5),
                    ],
                  ),
                const Spacer(),
              ],
            )
        )
    );
  }

  Future refresh() async{
    print(last_id);
    setState(() {
      _isloading = true;
    });
    await filterservermedia(last_id, categorySelectedData, isEnquiryData, productSelectedData, blockSelectedData, slabSelectedData).then((value){
      if(value.data!.isNotEmpty){
        setState(() {
          last_id = value.last_id;
          List<String> imglist = [];
          List<String> vidlist = [];
          for (var data in value.data!) {
            if(data.website_media.validate().contains('.mp4') || data.website_media.validate().contains('.MP4') || data.website_media.validate().contains('.MOV') || data.website_media.validate().contains('.mov')){
              String url = data.website_media.validate().toString().replaceFirst("http://","https://");
              vidlist.add("$url####@@@@####SB####@@@@####${data.block_name.validate()}####@@@@####SB####@@@@####${data.block_id.validate()}####@@@@####SB####@@@@####${data.product_name.validate()}" );
            }else if(data.website_media.validate().contains('.jpeg') || data.website_media.validate().contains('.jpg') || data.website_media.validate().contains('.png')){
              String url = data.website_media.validate().toString().replaceFirst("http://","https://");
              imglist.add("$url####@@@@####SB####@@@@####${data.block_name.validate()}####@@@@####SB####@@@@####${data.block_id.validate()}####@@@@####SB####@@@@####${data.product_name.validate()}");
            }
          }
          imageList.addAll(imglist);
          print(imageList.length);
          videoList.addAll(vidlist);
          print(videoList.length);
          last_id = value.last_id.validate();
        });
      }
    }).catchError((e) {
      setState(() {});
      log(e.toString());
    });
    setState(() {
      _isloading = false;
    });
  }

  Future filtermediadata(categorySelected, isEnquiry, productSelected, blockSelected, slabSelected) async {
    hideKeyboard(context);
    print("kkk");
    print(categorySelected);
    print(isEnquiry);
    print(productSelected);
    print(blockSelected);
    setState(() {
      categorySelectedData = categorySelected;
      isEnquiryData = isEnquiry;
      productSelectedData = productSelected;
      blockSelectedData = blockSelected;
      slabSelectedData = slabSelected;
    });
    await filterservermedia(null, categorySelected, isEnquiry, productSelected, blockSelected, slabSelected).then((value) {
      if(value.status == false){
        toast("No data found");
        finish(context);
      }
      if(value.data != null){
        if(value.data!.isNotEmpty){
          setState(() {
            List<String> imglist = [];
            List<String> vidlist = [];
            for (var data in value.data!) {
              if(data.website_media.validate().contains('.mp4') || data.website_media.validate().contains('.MP4') || data.website_media.validate().contains('.mov') || data.website_media.validate().contains('.MOV')){
                String url = data.website_media.validate().toString().replaceFirst("http://","https://");
                vidlist.add("$url####@@@@####SB####@@@@####${data.block_name.validate()}####@@@@####SB####@@@@####${data.block_id.validate()}####@@@@####SB####@@@@####${data.product_name.validate()}");
              }else if(data.website_media.validate().contains('.jpeg') || data.website_media.validate().contains('.jpg') || data.website_media.validate().contains('.png')){
                String url = data.website_media.validate().toString().replaceFirst("http://","https://");
                imglist.add("$url####@@@@####SB####@@@@####${data.block_name.validate()}####@@@@####SB####@@@@####${data.block_id.validate()}####@@@@####SB####@@@@####${data.product_name.validate()}");
              }
            }
            imageList = imglist ;
            print(imageList.length);
            videoList = vidlist;
            print(videoList.length);
            last_id = value.last_id.validate();
            finish(context);
          });
        }
      }
    }).catchError((e) {
      setState(() {});
      log(e.toString());
      toast(e.toString());
      finish(context);
    });
  }

  void filterDialog() {
    showInDialog(context, title: Text("Filter Media", style: boldTextStyle(), textAlign: TextAlign.justify), barrierColor: Colors.black45, backgroundColor: scaffoldBgColor,
        builder: (context) {
          return AddFilterDailog(filtermediadata : filtermediadata);
        }
    );
  }

  Future Refresh() async{
    print(last_id);
    setState(() {
      _isloading = true;
    });
    print(blockSelectedData);
    print("ijij");
    await filterservermedia(last_id, categorySelectedData, isEnquiryData, productSelectedData, blockSelectedData, slabSelectedData).then((value){
      if(value.data!.isNotEmpty){
        setState(() {
          List<String> imglist = [];
          List<String> vidlist = [];
          for (var data in value.data!) {
            if(data.website_media.validate().contains('.mp4') || data.website_media.validate().contains('.MP4') || data.website_media.validate().contains('.mov') || data.website_media.validate().contains('.MOV')){
              String url = data.website_media.validate().toString().replaceFirst("http://","https://");
              vidlist.add("$url####@@@@####SB####@@@@####${data.block_name.validate()}####@@@@####SB####@@@@####${data.block_id.validate()}####@@@@####SB####@@@@####${data.product_name.validate()}" );
            }else if(data.website_media.validate().contains('.jpeg') || data.website_media.validate().contains('.jpg') || data.website_media.validate().contains('.png')){
              String url = data.website_media.validate().toString().replaceFirst("http://","https://");
              imglist.add("$url####@@@@####SB####@@@@####${data.block_name.validate()}####@@@@####SB####@@@@####${data.block_id.validate()}####@@@@####SB####@@@@####${data.product_name.validate()}" );
            }
          }
          List<int> test = [1, 2, 3, 4, 5];
          List<int> dd = [];
          dd.addAll(test);
          print("LIST: ${dd.reversed}");
          imageList.addAll(imglist);
          imageList.reversed;
          print(imageList.length);
          videoList.addAll(vidlist);
          videoList.reversed;
          print(videoList.length);
          last_id = value.last_id.validate();
        });
      }
    }).catchError((e) {
      setState(() {});
      log(e.toString());
    });
    setState(() {
      _isloading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    print(isLoading);
    return SafeArea(
      child: Scaffold(
        appBar: appImageBar(context, name: 'Upload Images', filter: filterDialog, reload: refresh ),
        body: isLoading == true
            ? const Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: kPrimaryColor,
                strokeWidth: 2,
              ),
            )
        )
            : LiquidPullToRefresh(
          color: Colors.white,
          height: 100,
          animSpeedFactor: 2,
          backgroundColor: Colors.orange,
          showChildOpacityTransition: true,
          onRefresh: Refresh,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                HorizontalList(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: imageStatus.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: selectIndex == index
                            ? kPrimaryColor
                            : scaffoldBgColor,
                        borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
                      ),
                      child: FittedBox(
                        child: Text(
                          imageStatus[index],
                          style: primaryTextStyle(size: 14, color: selectIndex == index ? white : Theme.of(context).iconTheme.color),
                          textAlign: TextAlign.center,
                        ).paddingSymmetric(horizontal: 10, vertical: 2),
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
                if (is_gallary_image_long_press) ...[
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
                        child: CachedImageWidget(
                          url: _gallary_image.toString(),
                          height: 300,
                          width: 300,
                        ),
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: (selectIndex == 0)
                        ? uploadedMediaView()
                        : (selectIndex == 1)
                        ? buildGridView()
                        :(_isloading == true)
                        ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                            strokeWidth: 2,
                          ),
                        )
                    )
                        :serverGridView(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: (selectIndex == 1)
            ? (selectIndex == 1 && imagesList.isEmpty == false)
            ? AddFloatingButton(
          icon: FontAwesomeIcons.check,
          onTap: () async{
            editblockformData();
            imageList = [];
          },
        )
            : AddFloatingButton(
          icon: FontAwesomeIcons.upload,
          onTap: () async{
            showModalBottomSheet(
                context: context,
                builder:(BuildContext context){
                  return SizedBox(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              print("camera");
                              PermissionStatus cameraStatus = await Permission.camera.request();
                              if(cameraStatus == PermissionStatus.granted){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Permission Granted")));
                              }
                              // if(cameraStatus == PermissionStatus.denied){
                              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You need to provide camera permission")));
                              // }
                              // if(cameraStatus == PermissionStatus.permanentlyDenied){
                              //   openAppSettings();
                              // }
                              getcam();
                            },
                            color: Colors.orange.shade700,
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 24,
                            ),
                          ),
                          const Spacer(),
                          MaterialButton(
                            onPressed: getgalleryVideo,
                            color: Colors.orange.shade700,
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.video_camera_back,
                              size: 24,
                            ),
                          ),
                          const Spacer(),
                          MaterialButton(
                            onPressed: getgallery,
                            // _pickImagesFromGallery,
                            color: Colors.orange.shade700,
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.photo,
                              size: 24,
                            ),
                          ),

                        ],
                      ),
                    ),

                  );

                }
            );
          },
        )
            : (mediaImageList.isNotEmpty || uploadedMediaList.isNotEmpty)
            ? AddFloatingButton(
          icon: FontAwesomeIcons.check,
          onTap: () async{
            print("i");
            await editblockformData();
            mediaImageList = [];
          },
        )
            : Container(),

      ),
    );
  }


}