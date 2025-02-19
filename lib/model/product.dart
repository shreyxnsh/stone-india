class ProductListModel {
  List<ProductData>? productData;
  int? total;
  bool? status;

  ProductListModel({this.productData, this.total, this.status});

  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    return ProductListModel(
        productData: json['data'] != null ? (json['data'] as List).map((i) => ProductData.fromJson(i)).toList() : null,
        total: json['total'],
        status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['status'] = status;
    if (productData != null) {
      data['data'] = productData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductData {
  int? product_id;
  String? product_name;

  ProductData({this.product_id, this.product_name});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
        product_id: json['id'],
        product_name: json['name']

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = product_id;
    data['name'] = product_name;
    return data;
  }

}