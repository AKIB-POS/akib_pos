import 'package:equatable/equatable.dart';


class ProductModel {
  final int id;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String imageUrl;
  final int categoryId;
  final int subCategoryId;
  final int? variantId;
  final int? additionId;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.categoryId,
    required this.subCategoryId,
    this.variantId,
    this.additionId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: int.parse(json['price']),
      stock: int.parse(json['stock']),
      imageUrl: json['imageUrl'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      variantId: json['variant_id'] != null ? json['variant_id'] : null,
      additionId: json['addition_id'] != null ? json['addition_id'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price.toString(),
      'stock': stock.toString(),
      'imageUrl': imageUrl,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'variant_id': variantId,
      'addition_id': additionId,
    };
  }
}