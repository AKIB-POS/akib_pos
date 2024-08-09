import 'package:equatable/equatable.dart';

class SubCategoryModel extends Equatable {
  final int id;
  final String subCategoryName;
  final int count;

  SubCategoryModel({
    required this.id,
    required this.subCategoryName,
    required this.count,
  });

  @override
  List<Object> get props => [id, subCategoryName, count];

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      subCategoryName: json['sub_category_name'],
      count: json['count'],
    );
  }
}
