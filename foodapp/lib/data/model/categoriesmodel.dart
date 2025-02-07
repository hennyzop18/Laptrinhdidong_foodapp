class CategoriesModel {
  int? categoryId;
  String? categoryName;
  String? categoryImage;
  String? categoryDatetime;

  CategoriesModel(
      {this.categoryId,
      this.categoryName,
      this.categoryImage,
      this.categoryDatetime});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryImage = json['category_image'];
    categoryDatetime = json['category_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_image'] = this.categoryImage;
    data['category_datetime'] = this.categoryDatetime;
    return data;
  }
}
