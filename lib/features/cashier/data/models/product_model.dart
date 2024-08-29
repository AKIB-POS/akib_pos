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
  final int? totalPrice; // Field to store the total price

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
    this.totalPrice,
  });

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    int? price,
    int? stock,
    String? imageUrl,
    int? categoryId,
    int? subCategoryId,
    int? variantId,
    int? additionId,
    int? totalPrice,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      variantId: variantId ?? this.variantId,
      additionId: additionId ?? this.additionId,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

    /// Serialize only necessary fields for the API request
  Map<String, dynamic> toApiJson() {
    return {
      'id': id,
      'price': price,
      'total_price': totalPrice?.toString(),
    };
  }

  // Factory method to create a ProductModel from JSON
 factory ProductModel.fromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'],
    name: json['name'],
    description: json['description'] ?? '',  // Handle null description
    price: json['price'],
    stock: json['stock'],
    imageUrl: json['imageUrl'] ?? '',  // Handle null imageUrl
    categoryId: json['category_id'],
    subCategoryId: json['sub_category_id'],
    variantId: json['variant_id'],  // variantId can be null
    additionId: json['addition_id'],  // additionId can be null
    totalPrice: json['total_price'] != null ? int.parse(json['total_price']) : null,
  );
}

  // Method to convert ProductModel to JSON
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
      'variant_id': variantId,
      'addition_id': additionId,
      'total_price': totalPrice?.toString(),
    };
  }

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, description: $description, price: $price, stock: $stock, imageUrl: $imageUrl, categoryId: $categoryId, subCategoryId: $subCategoryId, variantId: $variantId, additionId: $additionId, totalPrice: $totalPrice}';
  }
}


class SelectedVariant {
  final int id;
  final String name;
  final int price;
  final String subVariantType;

  SelectedVariant({
    required this.id,
    required this.name,
    required this.price,
    required this.subVariantType,
  });

  factory SelectedVariant.fromJson(Map<String, dynamic> json) {
    return SelectedVariant(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      subVariantType: json['sub_variant_type'],
    );
  }

  /// Serialize only necessary fields for the API request
  Map<String, dynamic> toApiJson() {
    return {
      'id': id,
      'price': price,
    };
  }

  /// General purpose serialization (all fields)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'sub_variant_type': subVariantType,
    };
  }

  @override
  String toString() {
    return 'SelectedVariant{id: $id, name: $name, price: $price, subVariantType: $subVariantType}';
  }
}



class SelectedAddition {
  final int id;
  final String name;
  final int price;

  SelectedAddition({
    required this.id,
    required this.name,
    required this.price,
  });

  factory SelectedAddition.fromJson(Map<String, dynamic> json) {
    return SelectedAddition(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  /// Serialize only necessary fields for the API request
  Map<String, dynamic> toApiJson() {
    return {
      'id': id,
      'price': price.toString(),
    };
  }

  /// General purpose serialization (all fields)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'SelectedAddition{id: $id, name: $name, price: $price}';
  }
}
