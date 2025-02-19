class SlabListModel {
  List<SlabData>? slabData;
  int? total;
  bool? status;

  SlabListModel({this.slabData, this.total, this.status});

  factory SlabListModel.fromJson(Map<String, dynamic> json) {
    return SlabListModel(
        slabData: json['data'] != null ? (json['data'] as List).map((i) => SlabData.fromJson(i)).toList() : null,
        total: json['total'],
        status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['status'] = status;
    if (slabData != null) {
      data['data'] = slabData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlabData {
  int? slab_id;
  String? slab_name;

  SlabData({this.slab_id, this.slab_name});

  factory SlabData.fromJson(Map<String, dynamic> json) {
    return SlabData(
        slab_id: json['id'],
        slab_name: json['name']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = slab_id;
    data['name'] = slab_name;
    return data;
  }

}