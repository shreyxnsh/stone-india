class ThicknessListModel {
  List<ThicknessData>? thicknessData;
  int? total;
  bool? status;

  ThicknessListModel({this.thicknessData, this.total, this.status});

  factory ThicknessListModel.fromJson(Map<String, dynamic> json) {
    return ThicknessListModel(
        thicknessData: json['data'] != null ? (json['data'] as List).map((i) => ThicknessData.fromJson(i)).toList() : null,
        total: json['total'],
        status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['status'] = status;
    if (thicknessData != null) {
      data['data'] = thicknessData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ThicknessData {
  int? thickness_id;
  String? thickness_name;

  ThicknessData({this.thickness_id, this.thickness_name});

  factory ThicknessData.fromJson(Map<String, dynamic> json) {
    return ThicknessData(
        thickness_id: json['id'],
        thickness_name: json['name']

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = thickness_id;
    data['name'] = thickness_name;
    return data;
  }

}