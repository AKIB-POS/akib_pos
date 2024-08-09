import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int id;
  final String categoryName;
  final int count;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.count,
  });

  @override
  List<Object> get props => [id, categoryName, count];

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      categoryName: json['category_name'],
      count: json['count'],
    );
  }
}
