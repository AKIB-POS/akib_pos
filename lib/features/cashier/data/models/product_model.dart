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
  final List<SelectedVariant> selectedVariants;
  final List<SelectedAddition> selectedAdditions;
  final int? totalPrice; // New variable for storing total price

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
    required this.selectedVariants,
    required this.selectedAdditions,
    this.totalPrice, // Initialize the new variable
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
    List<SelectedVariant>? selectedVariants,
    List<SelectedAddition>? selectedAdditions,
    int? totalPrice, // Add the new variable to the copyWith method
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
      selectedVariants: selectedVariants ?? this.selectedVariants,
      selectedAdditions: selectedAdditions ?? this.selectedAdditions,
      totalPrice: totalPrice ?? this.totalPrice, // Add the new variable
    );
  }

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
      selectedVariants: [],
      selectedAdditions: [],
      totalPrice: json['total_price'] != null ? int.parse(json['total_price']) : null, // Handle the new variable
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
      'selected_variants': selectedVariants.map((variant) => variant.toJson()).toList(),
      'selected_additions': selectedAdditions.map((addition) => addition.toJson()).toList(),
      'total_price': totalPrice?.toString(), // Add the new variable to the JSON map
    };
  }

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, description: $description, price: $price, stock: $stock, imageUrl: $imageUrl, categoryId: $categoryId, subCategoryId: $subCategoryId, variantId: $variantId, additionId: $additionId, selectedVariants: $selectedVariants, selectedAdditions: $selectedAdditions, totalPrice: $totalPrice}';
  }
}


class SelectedVariant {
  final int id; // Add an ID field
  final String name;
  final int price;
  final String subVariantType;

  SelectedVariant({
    required this.id, // Include this in the constructor
    required this.name,
    required this.price,
    required this.subVariantType,
  });

  factory SelectedVariant.fromJson(Map<String, dynamic> json) {
    return SelectedVariant(
      id: json['id'], // Parse the ID from JSON
      name: json['name'],
      price: int.parse(json['price']),
      subVariantType: json['sub_variant_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include the ID in the toJson method
      'name': name,
      'price': price.toString(),
      'sub_variant_type': subVariantType,
    };
  }

  @override
  String toString() {
    return 'SelectedVariant{id: $id, name: $name, price: $price, subVariantType: $subVariantType}';
  }
}



class SelectedAddition {
  final int id; // Add an ID field
  final String name;
  final int price;

  SelectedAddition({
    required this.id, // Include this in the constructor
    required this.name,
    required this.price,
  });

  factory SelectedAddition.fromJson(Map<String, dynamic> json) {
    return SelectedAddition(
      id: json['id'], // Parse the ID from JSON
      name: json['name'],
      price: int.parse(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include the ID in the toJson method
      'name': name,
      'price': price.toString(),
    };
  }

  @override
  String toString() {
    return 'SelectedAddition{id: $id, name: $name, price: $price}';
  }
}
