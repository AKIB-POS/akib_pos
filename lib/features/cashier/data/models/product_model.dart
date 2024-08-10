import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final String price;
  final String stock;
  final String imageUrl;
  final int categoryId;
  final int subCategoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.categoryId,
    required this.subCategoryId,
  });

  @override
  List<Object> get props => [id, name, description, price, stock, imageUrl, categoryId, subCategoryId];

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      imageUrl: json['imageUrl'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
    };
  }
}
