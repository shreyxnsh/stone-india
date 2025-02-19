class BlockListModel {
  List<BlockData>? blockData;
  int? total;
  bool? status;

  BlockListModel({this.blockData, this.total, this.status});

  factory BlockListModel.fromJson(Map<String, dynamic> json) {
    return BlockListModel(
        blockData: json['data'] != null ? (json['data'] as List).map((i) => BlockData.fromJson(i)).toList() : null,
        total: json['total'],
        status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['status'] = status;
    if (blockData != null) {
      data['data'] = blockData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlockData {
  int? block_id;
  String? block_name;

  BlockData({this.block_id, this.block_name});

  factory BlockData.fromJson(Map<String, dynamic> json) {
    return BlockData(
        block_id: json['id'],
        block_name: json['name']

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = block_id;
    data['name'] = block_name;
    return data;
  }

}