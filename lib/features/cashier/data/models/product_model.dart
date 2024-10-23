import 'package:equatable/equatable.dart';
import 'dart:developer'; // Untuk log

class ProductModel {
  final int id;
  final String name;
  final String? description;
  final int price;
  final int stock;
  final String imageUrl;
  final String sku;
  final int unitId;
  final int categoryId;
  final int? subCategoryId;
  final int? variantId;
  final int? additionId;
  final int? totalPrice;
  final List<Discount>? discounts;
  final double? totalDiscount;
  final double? totalPriceDisc;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.sku,
    required this.unitId,
    required this.categoryId,
    this.subCategoryId,
    this.variantId,
    this.additionId,
    this.totalPrice,
    this.discounts,
    this.totalPriceDisc,
    this.totalDiscount,
  });

  /// Factory constructor with error handling for parsing
  factory ProductModel.fromJson(Map<String, dynamic> json) {
  try {
    var discountList = (json['discounts'] as List?)
        ?.map((item) => Discount.fromJson(item))
        .toList();

    // Parse fields that can be either num or String
    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      price: json['price'] is String
          ? int.tryParse(json['price']) ?? 0
          : (json['price'] as num?)?.toInt() ?? 0,
      stock: json['stock'] is String
          ? int.tryParse(json['stock']) ?? 0
          : (json['stock'] as num?)?.toInt() ?? 0,
      imageUrl: json['image_url'] ?? '',
      sku: json['sku'] ?? '',
      unitId: (json['unit_id'] as num?)?.toInt() ?? 0,
      categoryId: (json['category_id'] as num?)?.toInt() ?? 0,
      subCategoryId: (json['sub_category_id'] as num?)?.toInt(),
      variantId: (json['variant_id'] as num?)?.toInt(),
      additionId: (json['addition_id'] as num?)?.toInt(),
      totalPrice: json['total_price'] is String
          ? int.tryParse(json['total_price']) ?? 0
          : (json['total_price'] as num?)?.toInt(),
      discounts: discountList ?? [],
      totalDiscount: json['total_discount'] is String
          ? double.tryParse(json['total_discount']) ?? 0.0
          : (json['total_discount'] as num?)?.toDouble(),
    );
  } catch (e, stackTrace) {
    log('Error parsing ProductModel: $e', error: e, stackTrace: stackTrace);
    rethrow;
  }
}


  /// Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'sku': sku,
      'unit_id': unitId,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'variant_id': variantId,
      'addition_id': additionId,
      'total_price': totalPrice?.toString(),
      'discounts': discounts?.map((discount) => discount.toJson()).toList(),
      'total_discount': totalDiscount?.toString(),
    };
  }

  /// API-specific JSON serialization
  Map<String, dynamic> toApiJson() {
    return {
      'id': id,
      'price': price,
      'total_price': totalPrice?.toString(),
    };
  }

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, description: $description, price: $price, stock: $stock, imageUrl: $imageUrl, '
        'sku: $sku, unitId: $unitId, categoryId: $categoryId, subCategoryId: $subCategoryId, variantId: $variantId, '
        'additionId: $additionId, totalPrice: $totalPrice, totalDiscount: $totalDiscount}';
  }

  /// Copy method for immutability
  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    int? price,
    int? stock,
    String? imageUrl,
    String? sku,
    int? unitId,
    int? categoryId,
    int? subCategoryId,
    int? variantId,
    int? additionId,
    int? totalPrice,
    int? totalPriceDisc,
    List<Discount>? discounts,
    double? totalDiscount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      sku: sku ?? this.sku,
      unitId: unitId ?? this.unitId,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      variantId: variantId ?? this.variantId,
      additionId: additionId ?? this.additionId,
      totalPrice: totalPrice ?? this.totalPrice,
      discounts: discounts ?? this.discounts,
      totalDiscount: totalDiscount ?? this.totalDiscount,
    );
  }
}
class Discount {
  final String type;
  final double value;
  final String startDate;
  final String endDate;

  Discount({
    required this.type,
    required this.value,
    required this.startDate,
    required this.endDate,
  });

  /// Factory constructor for Discount with error handling
  factory Discount.fromJson(Map<String, dynamic> json) {
    try {
      // Mengubah value menjadi double dengan tryParse agar bisa menangani String atau num
      final dynamic value = json['value'];
      return Discount(
        type: json['type'] ?? '',
        value: value is String ? double.tryParse(value) ?? 0.0 : (value as num?)?.toDouble() ?? 0.0,
        startDate: json['start_date'] ?? '',
        endDate: json['end_date'] ?? '',
      );
    } catch (e, stackTrace) {
      // Log error dan stack trace
      log('Error parsing Discount: $e', error: e, stackTrace: stackTrace);
      rethrow; // Rethrow jika ingin menangani error di level lebih tinggi
    }
  }

  /// Convert Discount to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value.toString(),
      'start_date': startDate,
      'end_date': endDate,
    };
  }

  @override
  String toString() {
    return 'Discount{type: $type, value: $value, startDate: $startDate, endDate: $endDate}';
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
