class SoldProductModel {
  final String date;
  final String categoryName;
  final int totalItemsSold;
  final List<SubCategoryModel>? subCategories;

  SoldProductModel({
    required this.date,
    required this.categoryName,
    required this.totalItemsSold,
    this.subCategories,
  });

  factory SoldProductModel.fromJson(Map<String, dynamic> json) {
    var subCategoryList = json['sub_categories'] != null
        ? (json['sub_categories'] as List)
            .map((subCategory) => SubCategoryModel.fromJson(subCategory))
            .toList()
        : null;

    return SoldProductModel(
      date: json['date'],
      categoryName: json['category_name'],
      totalItemsSold: json['total_items_sold'],
      subCategories: subCategoryList,
    );
  }
}

class SubCategoryModel {
  final String subCategoryName;
  final int itemsSold;

  SubCategoryModel({
    required this.subCategoryName,
    required this.itemsSold,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      subCategoryName: json['sub_category_name'],
      itemsSold: json['items_sold'],
    );
  }
}
