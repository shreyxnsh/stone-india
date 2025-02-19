class BlockFormListModel {
  List<BlockFormData>? blockFormData;
  int? total;
  bool? status;
  String? message;
  int? total_block_form_count;
  int? last_id;

  BlockFormListModel({this.blockFormData, this.total, this.status, this.message, this.last_id, this.total_block_form_count});

  factory BlockFormListModel.fromJson(Map<String, dynamic> json) {
    return BlockFormListModel(
        blockFormData: json['data'] != null ? (json['data'] as List).map((i) => BlockFormData.fromJson(i)).toList() : null,
        total: json['total'],
        total_block_form_count: json['total_block_form'],
        status: json['status'],
        message: json['message'],
        last_id: json['last_id']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['total_block_form'] = total_block_form_count;
    data['status'] = status;
    data['message'] = message;
    data['last_id'] =  last_id;
    if (blockFormData != null) {
      data['data'] = blockFormData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlockFormData {
  int? id;
  String? block_name;
  String? product_name;
  String? category_name;
  String? form_type;
  String? slab_type_name;
  String? slab_height;
  String? slab_length;
  String? slab_thickness;
  String? total_slabs;
  String? form_status;
  String? upload_date;
  List<BlockImages>? images;
  List<HoldByInformation>? holdby;

  BlockFormData({
    this.id, this.block_name, this.product_name, this.category_name, this.form_type, this.slab_type_name, this.slab_height, this.slab_length, this.slab_thickness, this.total_slabs, this.form_status, this.images, this.holdby, this.upload_date});

  factory BlockFormData.fromJson(Map<String, dynamic> json) {
    return BlockFormData(
        id: json['id'],
        block_name: json['block_name'],
        product_name: json['product_name'],
        category_name: json['category_name'],
        form_type: json['form_type'],
        slab_type_name: json['slab_type_name'],
        slab_height: json['slab_height'].toString(),
        slab_length: json['slab_length'].toString(),
        slab_thickness: json['slab_thickness'].toString(),
        total_slabs: json['total_slabs'].toString(),
        form_status: json['form_status'],
        upload_date: json['created_at'],
        images: json['image'] != null ? (json['image'] as List).map((i) => BlockImages.fromJson(i)).toList() : null,
        holdby: json['hold_by'] != null ? (json['hold_by'] as List).map((i) => HoldByInformation.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['block_name'] = block_name;
    data['product_name'] = product_name;
    data['category_name'] = category_name;
    data['form_type'] = form_type;
    data['slab_type_name'] = slab_type_name;
    data['slab_height'] = slab_height.toString();
    data['slab_length'] = slab_length.toString();
    data['slab_thickness'] = slab_thickness.toString();
    data['total_slabs'] = total_slabs.toString();
    data['created_at'] = upload_date;
    data['form_status'] = form_status;
    if (images != null) {
      data['image'] = images!.map((v) => v.toJson()).toList();
    }
    if (holdby != null) {
      data['hold_by'] = holdby!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlockImages {
  String? image;

  BlockImages({this.image});

  factory BlockImages.fromJson(Map<String, dynamic> json) {
    return BlockImages(
        image: json['url']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = image;
    return data;
  }
}

class HoldByInformation {
  int? id;
  String? role;
  String? firstname;
  String? lastname;
  String? email;
  String? whatsapp_number;

  HoldByInformation({this.id, this.role, this.firstname, this.lastname, this.email, this.whatsapp_number});

  factory HoldByInformation.fromJson(Map<String, dynamic> json) {
    return HoldByInformation(
      id: json['id'],
      role: json['role'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      whatsapp_number: json['whatsapp_number']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['whatsapp_number'] = whatsapp_number;
    return data;
  }
}