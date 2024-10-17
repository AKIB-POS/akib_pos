class SoldProductModel {
  final String date;
  final String categoryName;
  final double totalItemsSold;
  final List<SubCategoryModel>? subCategories;
  final String? subCategoryText;  // Untuk menampung kondisi sub_category sebagai String

  SoldProductModel({
    required this.date,
    required this.categoryName,
    required this.totalItemsSold,
    this.subCategories,
    this.subCategoryText,  // Tambahkan parameter untuk string
  });

  factory SoldProductModel.fromJson(Map<String, dynamic> json) {
    // Cek apakah sub_categories adalah list atau string
    var subCategoryList;
    String? subCategoryString;

    if (json['sub_categories'] is List) {
      subCategoryList = (json['sub_categories'] as List)
          .map((subCategory) => SubCategoryModel.fromJson(subCategory))
          .toList();
    } else if (json['sub_categories'] is String) {
      subCategoryString = json['sub_categories'];
    }

    return SoldProductModel(
      date: json['date'] ?? '',
      categoryName: json['category_name'] ?? '',
      totalItemsSold: (json['total_items_sold'] as num?)?.toDouble() ?? 0.0,
      subCategories: subCategoryList,  // List jika ada
      subCategoryText: subCategoryString,  // String jika ada
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'category_name': categoryName,
      'total_items_sold': totalItemsSold,
      'sub_categories': subCategories != null
          ? subCategories?.map((e) => e.toJson()).toList()  // Kembalikan List jika ada
          : subCategoryText,  // Kembalikan String jika ada
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
