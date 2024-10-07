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
      date: json['date'] ?? '',
      categoryName: json['category_name'] ?? '',
      totalItemsSold: (json['total_items_sold'] as num?)?.toInt() ?? 0,
      subCategories: subCategoryList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'category_name': categoryName,
      'total_items_sold': totalItemsSold,
      'sub_categories': subCategories?.map((e) => e.toJson()).toList(),
    };
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
      subCategoryName: json['sub_category_name'] ?? '',
      itemsSold: (json['items_sold'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_category_name': subCategoryName,
      'items_sold': itemsSold,
    };
  }
}
