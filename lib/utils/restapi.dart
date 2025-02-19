import 'dart:convert';
import 'dart:io';

import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/block.dart';
import 'package:stoneindia/model/blockform.dart';
import 'package:stoneindia/model/category.dart';
import 'package:stoneindia/model/notification.dart';
import 'package:stoneindia/model/product.dart';
import 'package:stoneindia/model/profile.dart';
import 'package:stoneindia/model/servermedia.dart';
import 'package:stoneindia/model/slab.dart';
import 'package:http/http.dart' as http;
import 'package:stoneindia/model/thickness.dart';

import 'network_utils.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


Future login(Map request) async {
  return await (handleResponse(await buildHttpResponse('login', request: request, method: HttpMethod.POST)));
}

Future register(Map request) async {
  return await (handleResponse(await buildHttpResponse('signup', request: request, method: HttpMethod.POST)));
}

Future<BlockFormListModel> fetchblockform({int? last_id}) async {
  final data = await (handleResponse(await buildHttpResponse('get/block/form?last_id=$last_id', method: HttpMethod.GET)));
  return BlockFormListModel.fromJson(data);
}

Future<BlockFormListModel> fetchcustomerblockform({int? last_id, int? customer_id}) async {
  final data = await (handleResponse(await buildHttpResponse('fetch/hold/block?last_id=$last_id&user_id=$customer_id', method: HttpMethod.GET)));
  return BlockFormListModel.fromJson(data);
}

Future<BlockFormListModel> fetchholdblockform({int? last_id}) async {
  final data = await (handleResponse(await buildHttpResponse('fetch/all/hold/blocks?last_id=$last_id', method: HttpMethod.GET)));
  return BlockFormListModel.fromJson(data);
}

Future<BlockFormListModel> fetchcustomerholdblockform({int? last_id, int? user_id}) async {
  final data = await (handleResponse(await buildHttpResponse('fetch/only/hold/block?user_id=$user_id&last_id=$last_id', method: HttpMethod.GET)));
  return BlockFormListModel.fromJson(data);
}

Future<BlockFormListModel> fetchsoldblockform({int? last_id}) async {
  final data = await (handleResponse(await buildHttpResponse('fetch/all/sold/blocks?last_id=$last_id', method: HttpMethod.GET)));
  return BlockFormListModel.fromJson(data);
}

Future addblock(Map request) async {
  final data = await (handleResponse(await buildHttpResponse('add/block', request: request, method: HttpMethod.POST)));
  return data;
}

Future deleteblock({int? form_id}) async {
  final data = await (handleResponse(await buildHttpResponse('delete/block?form_id=$form_id', method: HttpMethod.POST)));
  return data;
}

Future deleteblockk({int? block_id}) async {
  final data = await (handleResponse(await buildHttpResponse('block/delete?block_id=$block_id', method: HttpMethod.POST)));
  return data;
}

Future editblock({int? block_id, String? name}) async {
  final data = await (handleResponse(await buildHttpResponse('update/block?block_id=$block_id&name=$name', method: HttpMethod.POST)));
  return data;
}

Future editproduct({int? product_id, String? name}) async {
  final data = await (handleResponse(await buildHttpResponse('update/product?product_id=$product_id&name=$name', method: HttpMethod.POST)));
  return data;
}

Future editcategory({int? category_id, String? name}) async {
  final data = await (handleResponse(await buildHttpResponse('update/category?category_id=$category_id&name=$name', method: HttpMethod.POST)));
  return data;
}

Future editslab({int? slab_id, String? name}) async {
  final data = await (handleResponse(await buildHttpResponse('update/slab?slab_id=$slab_id&name=$name', method: HttpMethod.POST)));
  return data;
}

Future deletecatagory({int? category_id}) async {
  final data = await (handleResponse(await buildHttpResponse('category/delete?category_id=$category_id', method: HttpMethod.POST)));
  return data;
}

Future deleteproduct({int? product_id}) async {
  final data = await (handleResponse(await buildHttpResponse('product/delete?product_id=$product_id', method: HttpMethod.POST)));
  return data;
}

Future deleteslab({int? slab_id}) async {
  final data = await (handleResponse(await buildHttpResponse('slab/delete?slab_id=$slab_id', method: HttpMethod.POST)));
  return data;
}

Future sendContact(Map request) async {
  final data = await (handleResponse(await buildHttpResponse('fetch/contacts', request: request, method: HttpMethod.POST)));
  return data;
}

Future<BlockListModel> fetchblock() async {
  final data = await (handleResponse(await buildHttpResponse('get/block', method: HttpMethod.GET)));
  return BlockListModel.fromJson(data);
}

Future addproduct(Map request) async {
  final data = await (handleResponse(await buildHttpResponse('add/product', request: request, method: HttpMethod.POST)));
  return data;
}

Future<ProductListModel> fetchproduct() async {
  final data = await (handleResponse(await buildHttpResponse('get/product', method: HttpMethod.GET)));
  return ProductListModel.fromJson(data);
}

Future addcategory(Map request) async {
  final data = await (handleResponse(await buildHttpResponse('add/category', request: request, method: HttpMethod.POST)));
  return data;
}

Future<CategoryListModel> fetchcategory() async {
  final data = await (handleResponse(await buildHttpResponse('get/category', method: HttpMethod.GET)));
  return CategoryListModel.fromJson(data);
}

Future addslab(Map request) async {
  final data = await (handleResponse(await buildHttpResponse('add/slab/type', request: request, method: HttpMethod.POST)));
  return data;
}

Future<SlabListModel> fetchslab() async {
  final data = await (handleResponse(await buildHttpResponse('get/slab', method: HttpMethod.GET)));
  return SlabListModel.fromJson(data);
}

Future<ServerMediaListModel> fetchmedia() async  {
  return ServerMediaListModel.fromJson( await handleResponse(await buildHttpResponseFromSB('https://stonebharat.in/api/website_media/', method: HttpMethod.GET)));
}

Future<ServerMediaListModel> fetchservermedia({int? last_id}) async  {
  return ServerMediaListModel.fromJson( await handleResponse(await buildHttpResponse('fetch/website/media?last_id=$last_id', method: HttpMethod.GET)));
}

Future<ServerMediaListModel> fetchmediafromnexturl(String? url) async  {
  return ServerMediaListModel.fromJson( await handleResponse(await buildHttpResponseFromSB(url.validate(), method: HttpMethod.GET)));
}

Future<List> fetchserverproduct() async  {
  Iterable data =  await handleResponse(await buildHttpResponseFromSB('https://stonebharat.in/api/product/', method: HttpMethod.GET));
  List<String> list = [];
  for (var element in data) {
    list.add("${element["product_name"]} ###@@@###SB###@@@### ${element["id"]}");
  }
  return list;
}

Future<List> fetchserverblock() async  {
  Iterable data =  await handleResponse(await buildHttpResponseFromSB('https://stonebharat.in/api/readyblockdropdown/', method: HttpMethod.GET));
  List<String> list = [];
  for (var element in data) {
    list.add("${element["block_number"]} ###@@@###SB###@@@### ${element["id"]}");
  }
  return list;
}

Future<ServerMediaListModel> filtermedia(typeSelected, isEnquiry, productSelected, blockSelected) async  {
  var url = 'https://stonebharat.in/api/website_media/';
  if(typeSelected != null || isEnquiry != null || productSelected != null || blockSelected!= null){
    url = '$url?';
    if(typeSelected != null){
      url = '${url}type=$typeSelected&';
    }
    if(isEnquiry != null){
      url = '${url}product_type=$isEnquiry&';
    }
    if(productSelected != null){
      url = '${url}factory_product=$productSelected&';
    }
    if(blockSelected != null){
      url = '${url}block=$blockSelected&';
    }
  }
  print("URL: ");
  print(url);
  return ServerMediaListModel.fromJson( await handleResponse(
      await buildHttpResponseFromSB(url.validate(), method: HttpMethod.GET)));
}

Future<ServerMediaListModel> filterservermedia(lastId, categorySelected, isEnquiry, productSelected, blockSelected, slabSelected) async  {
  var url = 'fetch/website/media?last_id=$lastId&';
  if(categorySelected != null || isEnquiry != null || productSelected != null || blockSelected!= null || slabSelected != null){
    if(categorySelected != null){
      url = '${url}category_name=$categorySelected&';
    }
    if(isEnquiry != null){
      url = '${url}type=$isEnquiry&';
    }
    if(productSelected != null){
      url = '${url}product_name=$productSelected&';
    }
    if(blockSelected != null){
      url = '${url}block=$blockSelected&';
    }
    if(slabSelected != null){
      url = '${url}slab_type=$slabSelected&';
    }
  }
  print("URL: ");
  print(url);
  return ServerMediaListModel.fromJson( await handleResponse(
      await buildHttpResponse(url.validate(), method: HttpMethod.GET)));
}

Future<ProfileModel> getUserProfile(int? id, String? role) async {
  var data =  ProfileModel.fromJson(await (handleResponse(await buildHttpResponse('get/details?user_id=$id&role=$role', method: HttpMethod.POST))));
  return data;
}

Future<NotificationListModel> getnotification({int? user_id}) async {
  var data =  NotificationListModel.fromJson(await (handleResponse(await buildHttpResponse('get/notification?user_id=$user_id', method: HttpMethod.POST))));
  return data;
}

Future<List<File>> convertFilePathsToFiles(List<String> filePaths) async {
  List<File> files = [];

  for (String path in filePaths) {
    File file = File(path);
    if (await file.exists()) {
      files.add(file);
    }
  }

  return files;
}

Future sendContactJsonFile(Map data, {String? filePath}) async {
  var multiPartRequest = await getMultiPartRequest('test/json/data');
  multiPartRequest.fields['user_id'] = data['user_id'];
  if (filePath != null) {
    File dd = File(filePath.toString());
    if (dd.existsSync()) {
      print("exist");
      multiPartRequest.files.add( http.MultipartFile(
          'json_file', dd.readAsBytes().asStream(), dd.lengthSync(),
          filename: dd.toString().split('/').last.split('\'')[0]));
    } else {
      print("Not exist");
    }
  }
  multiPartRequest.headers.addAll(buildHeaderTokens());
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  print("Response: ");
  print(response.body);
  if (response.statusCode.isSuccessful()) {

    if(jsonDecode(response.body)['status'] == false){
      toast(jsonDecode(response.body)['messages']);
      return true;
    }

    return true;
  }else {
    return false;
  }
  return false;
}

Future<bool> addBlockForm(Map data, List<String> mediaList, {List<String>? file, String? toastMessage}) async {
  var multiPartRequest = await getMultiPartRequest('add/block/details');
  multiPartRequest.fields['user_id'] = data['user_id'];
  multiPartRequest.fields['block_name'] = data['block_name'];
  multiPartRequest.fields['product_name'] = data['product_name'];
  multiPartRequest.fields['category_name'] = data['category_name'];
  multiPartRequest.fields['form_type'] = data['form_type'];
  multiPartRequest.fields['slab_type_name'] = data['slab_type_name'];
  multiPartRequest.fields['slab_height'] = data['slab_height'];
  multiPartRequest.fields['slab_length'] = data['slab_length'];
  multiPartRequest.fields['slab_thickness'] = data['slab_thickness'];
  multiPartRequest.fields['total_slabs'] = data['total_slabs'];

  if(mediaList.isNotEmpty){
    String listJson = mediaList.join(',');
    multiPartRequest.fields['website_media'] = listJson;
  }

  if (file != null) {
    if (file.isNotEmpty) {
      for (var i = 0; i <= file.length - 1; i++) {
        File dd = File(file[i].toString());
        if (dd.existsSync()) {
          print("exist");
          multiPartRequest.files.add( http.MultipartFile(
              'image[]', dd.readAsBytes().asStream(), dd.lengthSync(),
              filename: dd.toString().split('/').last.split('\'')[0]));
        } else {
          print("Not exist");
        }
      }
    }
  }



  multiPartRequest.headers.addAll(buildHeaderTokens());
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  print("Response: ");
  print(response.body);
  if (response.statusCode.isSuccessful()) {

    if(jsonDecode(response.body)['status'] == false){
      toast(jsonDecode(response.body)['messages']);
      return true;
    }

    toast(toastMessage ?? 'Block added successfully');

    return true;
  }else {
    toast(errorSomethingWentWrong);
    return false;
  }
  return false;
}


Future<bool> editBlockForm(Map data, List<String> mediaList, {List<String>? file, String? toastMessage}) async {
  var multiPartRequest = await getMultiPartRequest('edit/block');
  multiPartRequest.fields['block_id'] = data['block_id'];
  multiPartRequest.fields['user_id'] = data['user_id'];
  multiPartRequest.fields['block_name'] = data['block_name'];
  multiPartRequest.fields['product_name'] = data['product_name'];
  multiPartRequest.fields['category_name'] = data['category_name'];
  multiPartRequest.fields['form_type'] = data['form_type'];
  multiPartRequest.fields['slab_type_name'] = data['slab_type_name'];
  multiPartRequest.fields['slab_height'] = data['slab_height'];
  multiPartRequest.fields['slab_length'] = data['slab_length'];
  multiPartRequest.fields['slab_thickness'] = data['slab_thickness'];
  multiPartRequest.fields['total_slabs'] = data['total_slabs'];

  if(mediaList.isNotEmpty){
    String listJson = mediaList.join(',');
    multiPartRequest.fields['website_media'] = listJson;
  }

  if (file != null) {
    if (file.isNotEmpty) {
      for (var i = 0; i <= file.length - 1; i++) {
        File dd = File(file[i].toString());
        if (dd.existsSync()) {
          print("exist");
          multiPartRequest.files.add( http.MultipartFile(
              'image[]', dd.readAsBytes().asStream(), dd.lengthSync(),
              filename: dd.toString().split('/').last.split('\'')[0]));
        } else {
          print("Not exist");
        }
      }
    }
  }

  multiPartRequest.headers.addAll(buildHeaderTokens());
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  print("Response: ");
  print(response.body);
  if (response.statusCode.isSuccessful()) {

    if(jsonDecode(response.body)['status'] == false){
      toast(jsonDecode(response.body)['messages']);
      return true;
    }

    toast(toastMessage ?? 'Block updated successfully');

    return true;
  }else {
    toast(errorSomethingWentWrong);
    return false;
  }
  return false;
}


Future<File> saveImagePermanently(String imagePath) async{
  print(imagePath);
  final directory = await getExternalStorageDirectory();
  final name = path.basename(imagePath);
  final image = File('${directory?.path}/$name');
  print(image.path);
  File copyfile = await File(imagePath).copy(image.path);
  print("Copy file: $copyfile");
  return File(imagePath).copy(image.path);
}

Future<bool> updateProfile(Map data, {File? file, String? toastMessage}) async {
  var multiPartRequest = await getMultiPartRequest('edit/profile');
  multiPartRequest.fields['user_id'] = data['user_id'];
  multiPartRequest.fields['firstname'] = data['firstname'];
  multiPartRequest.fields['lastname'] = data['lastname'];
  multiPartRequest.fields['address'] = data['address'];
  multiPartRequest.fields['city'] = data['city'];
  multiPartRequest.fields['state'] = data['state'];
  multiPartRequest.fields['country'] = data['country'];
  if (file != null) {
    multiPartRequest.files.add(http.MultipartFile(
        'profile_img', file.readAsBytes().asStream(), file.lengthSync(),
        filename: file.toString().split('/').last.split('\'')[0]));
  }
  multiPartRequest.headers.addAll(buildHeaderTokens());
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  print("Response: ");
  print(response.body);
  if (response.statusCode.isSuccessful()) {

    if(jsonDecode(response.body)['status'] == false){
      toast(jsonDecode(response.body)['messages']);
      return true;
    }
    ProfileModel data = ProfileModel.fromJson(jsonDecode(response.body));
    setValue(FIRST_NAME, data.first_name.validate());
    setValue(LAST_NAME, data.last_name.validate());
    setValue(USER_MOBILE, data.mobile_number.validate());

    if (data.profile_image != null) {
      setValue(PROFILE_IMAGE, data.profile_image.validate());
    }

    toast(toastMessage ?? 'Profile updated successfully');

    return true;
  }else {
    toast(errorSomethingWentWrong);
    return false;
  }
}

Future holdblock({int? form_id, int? customer_id}) async {
  final data = await (handleResponse(await buildHttpResponse('hold/block?form_id=$form_id&customer_id=$customer_id', method: HttpMethod.POST)));
  return data;
}

Future holdblockteam({int? form_id, int? team_id}) async {
  final data = await (handleResponse(await buildHttpResponse('hold/block/team?form_id=$form_id&team_id=$team_id', method: HttpMethod.POST)));
  return data;
}

Future soldblock({int? form_id, int? team_id}) async {
  final data = await (handleResponse(await buildHttpResponse('sold/block?form_id=$form_id&team_id=$team_id', method: HttpMethod.POST)));
  return data;
}

Future unsoldblock({int? form_id, int? team_id}) async {
  final data = await (handleResponse(await buildHttpResponse('unsold/block?form_id=$form_id&team_id=$team_id', method: HttpMethod.POST)));
  return data;
}

Future unholdblock({int? form_id}) async {
  final data = await (handleResponse(await buildHttpResponse('unhold/block/team?form_id=$form_id', method: HttpMethod.POST)));
  return data;
}

Future sendenquiry({int? customer_id, String? usernumber}) async {
  final data = await (handleResponse(await buildHttpResponse('add/inquiry?user_id=$customer_id&user_number=$usernumber', method: HttpMethod.POST)));
  return data;
}

Future getallphotosonwhatsapp({int? block_id, int? user_id}) async{
  final data = await( handleResponse(await buildHttpResponse('send/block/request?block_id=$block_id&user_id=$user_id',method:HttpMethod.POST )));
  return data;
}

Future deleteAccount({int? userid}) async{
  return await handleResponse(await buildHttpResponse('delete/user?user_id=$userid', method: HttpMethod.POST));
}

Future fetchTermsAndCondition() async{
  return await (handleResponse(await buildHttpResponse('terms-and-conditions/fetch', method: HttpMethod.GET)));
}

Future aboutUs() async{
  return await (handleResponse(await buildHttpResponse('about/us/setting/fetch', method: HttpMethod.GET)));
}

Future<BlockFormListModel> cataloguecustomerfilter({int? user_id, int? last_id, String? selectedType,String? selectedProduct, String? selectedBlock, String? selectedCategory,String? selectedSlab, String? slab_thickness}) async{
  final data = await(handleResponse(await buildHttpResponse('filter/customer/blocks?user_id=$user_id&type=$selectedType&block=$selectedBlock&product=$selectedProduct&category=$selectedCategory&slab_type=$selectedSlab&slab_thickness=$slab_thickness&last_id=$last_id',method: HttpMethod.GET)));
  return BlockFormListModel.fromJson(data);
}

Future<BlockFormListModel> cataloguefilter({int? last_id, String? selectedType,String? selectedProduct, String? selectedBlock, String? selectedCategory,String? selectedSlab, String? slab_thickness, String? date}) async{
  final data = await(handleResponse(await buildHttpResponse('filter/blocks?type=$selectedType&block=$selectedBlock&product=$selectedProduct&category=$selectedCategory&slab_type=$selectedSlab&slab_thickness=$slab_thickness&date=$date&last_id=$last_id',method: HttpMethod.GET)));
  return BlockFormListModel.fromJson(data);
}

Future accountDeleteStatus(int? userid) async{
  return await (handleResponse(await buildHttpResponse('check/account/delete/status?user_id=$userid', method: HttpMethod.GET)));
}

Future<ThicknessListModel> fetchthicknesslist() async {
  final data = await (handleResponse(await buildHttpResponse('get/thickness', method: HttpMethod.GET)));
  return ThicknessListModel.fromJson(data);
}

Future addthickness(Map request) async {
  final data = await (handleResponse(await buildHttpResponse('add/thickness', request: request, method: HttpMethod.POST)));
  return data;
}

Future deletethickness({int? thickness_id}) async {
  final data = await (handleResponse(await buildHttpResponse('thickness/delete?thickness_id=$thickness_id', method: HttpMethod.POST)));
  return data;
}

Future editthickness({int? thickness_id, String? name}) async {
  final data = await (handleResponse(await buildHttpResponse('update/thickness?thickness_id=$thickness_id&name=$name', method: HttpMethod.POST)));
  return data;
}