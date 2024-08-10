import 'package:equatable/equatable.dart';


class SubCategoryModel extends Equatable {
  final int id;
  final String subCategoryName;
  final int count;
  final int categoryId;

  SubCategoryModel({
    required this.id,
    required this.subCategoryName,
    required this.count,
    required this.categoryId,
  });

  @override
  List<Object> get props => [id, subCategoryName, count, categoryId];

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      subCategoryName: json['sub_category_name'],
      count: json['count'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_category_name': subCategoryName,
      'count': count,
      'category_id': categoryId,
    };
  }
}
