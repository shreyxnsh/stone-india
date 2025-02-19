// class ServerMediaListModel {
//   List<ServerMediaData>? results;
//   int? count;
//   String? nexturl;
//   String? previousurl;
//
//   ServerMediaListModel({this.results, this.count, this.nexturl, this.previousurl});
//
//   factory ServerMediaListModel.fromJson(Map<String, dynamic> json) {
//     return ServerMediaListModel(
//         results: json['results'] != null ? (json['results'] as List).map((i) => ServerMediaData.fromJson(i)).toList() : null,
//         count: json['count'],
//         nexturl: json['next'],
//         previousurl: json['previous']
//     );
//   }
//
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['count'] = this.count;
//     data['next'] = this.nexturl;
//     data['previous'] = this.previousurl;
//     if (this.results != null) {
//       data['results'] = this.results!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ServerMediaData {
//   int? id;
//   String? factory_product_name;
//   String? block_id;
//   String? block_name;
//   int? slabs;
//   int? sold_slabs;
//   int? total_stock_slabs;
//   bool? balanced_lot;
//   String? date;
//   String? title;
//   String? text;
//   String? type;
//   String? message_id;
//   String? media_id;
//   String? fileAddress;
//   String? fileName;
//   String? mimetype;
//   String? website_media;
//   String? reduced_image;
//   int? block;
//   int? block_media;
//   int? price;
//
//   ServerMediaData({
//     this.id,
//     this.factory_product_name,
//     this.block_id,
//     this.block_name,
//     this.slabs,
//     this.sold_slabs,
//     this.total_stock_slabs,
//     this.balanced_lot,
//     this.date,
//     this.title,
//     this.text,
//     this.type,
//     this.media_id,
//     this.fileAddress,
//     this.fileName,
//     this.mimetype,
//     this.website_media,
//     this.reduced_image,
//     this.block,
//     this.block_media,
//     this.price
//   });
//
//   factory ServerMediaData.fromJson(Map<String, dynamic> json) {
//     return ServerMediaData(
//         id: json['id'],
//         factory_product_name: json['factory_product_name'],
//         block_id: json['block_number'],
//         block_name: json['block_product_name'],
//         // slabs: json['slabs'],
//         // sold_slabs: json['sold_slabs'],
//         // total_stock_slabs: json['total_stock_slabs'],
//         // balanced_lot: json['balanced_lot'],
//         // date: json['date'],
//         // title: json['title'],
//         // text: json['text'],
//         // type: json['type'],
//         // media_id: json['media_id'],
//         // fileAddress: json['fileAddress'],
//         // fileName: json['fileName'],
//         // mimetype: json['mimetype'],
//         website_media: json['website_media'],
//         // reduced_image: json['reduced_image'],
//         block: json['block'],
//         // block_media: json['block_media'],
//         // price: json['price']
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['factory_product_name'] = this.factory_product_name;
//     data['block_number'] = this.block_id;
//     data['block_product_name'] = this.block_name;
//     // data['slabs'] = this.slabs;
//     // data['sold_slabs'] = this.sold_slabs;
//     // data['total_stock_slabs'] = this.total_stock_slabs;
//     // data['balanced_lot']= this.balanced_lot;
//     // data['date'] = this.date;
//     // data['title'] = this.title;
//     // data['text'] = this.text;
//     // data['type'] = this.type;
//     // data['media_id'] = this.media_id;
//     // data['fileAddress'] = this.fileAddress;
//     // data['fileName'] = this.fileName;
//     // data['mimetype'] = this.mimetype;
//     data['website_media'] = this.website_media;
//     // data['reduced_image'] = this.reduced_image;
//     data['block'] = this.block;
//     // data['block_media'] = this.block_media;
//     // data['price'] = this.price;
//     return data;
//   }
//
// }

class ServerMediaListModel {
  List<ServerMediaData>? data;
  int? total;
  bool? status;
  int? last_id;

  ServerMediaListModel({this.data, this.total, this.status, this.last_id});

  factory ServerMediaListModel.fromJson(Map<String, dynamic> json) {
    return ServerMediaListModel(
        data: json['data'] != null ? (json['data'] as List).map((i) => ServerMediaData.fromJson(i)).toList() : null,
        total: json['total'],
        last_id: json['last_id'],
        status: json['status']
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['last_id'] = last_id;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServerMediaData {
  int? id;
  String? block_name;
  int? block_id;
  String? product_name;
  String? website_media;

  ServerMediaData({
    this.id,
    this.block_name,
    this.block_id,
    this.product_name,
    this.website_media,
  });

  factory ServerMediaData.fromJson(Map<String, dynamic> json) {
    return ServerMediaData(
      id: json['media_id'],
      block_name: json['block_name'],
      block_id: json['block_id'],
      product_name: json['product_name'],
      website_media: json['media'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media_id'] = id;
    data['block_name'] = block_name;
    data['block_id'] = block_id;
    data['product_name'] = product_name;
    data['media'] =  website_media;
    return data;
  }

}