class CategoryListModel {
  List<CategoryData>? categoryData;
  int? total;
  bool? status;

  CategoryListModel({this.categoryData, this.total, this.status});

  factory CategoryListModel.fromJson(Map<String, dynamic> json) {
    return CategoryListModel(
        categoryData: json['data'] != null ? (json['data'] as List).map((i) => CategoryData.fromJson(i)).toList() : null,
        total: json['total'],
        status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['status'] = status;
    if (categoryData != null) {
      data['data'] = categoryData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  int? category_id;
  String? category_name;

  CategoryData({this.category_id, this.category_name});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
        category_id: json['id'],
        category_name: json['name']

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = category_id;
    data['name'] = category_name;
    return data;
  }

}