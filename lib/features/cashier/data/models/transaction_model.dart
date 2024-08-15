import 'package:akib_pos/features/cashier/data/models/product_model.dart';

class TransactionModel {
  final ProductModel product;
  final List<SelectedVariant> selectedVariants;
  final List<SelectedAddition> selectedAdditions;
  final String notes;
  final int quantity;

  TransactionModel({
    required this.product,
    required this.selectedVariants,
    required this.selectedAdditions,
    required this.notes,
    required this.quantity,
  });

  TransactionModel copyWith({
    ProductModel? product,
    List<SelectedVariant>? selectedVariants,
    List<SelectedAddition>? selectedAdditions,
    String? notes,
    String? savedNotes,
    int? quantity,
  }) {
    return TransactionModel(
      product: product ?? this.product,
      selectedVariants: selectedVariants ?? this.selectedVariants,
      selectedAdditions: selectedAdditions ?? this.selectedAdditions,
      notes: notes ?? this.notes,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'selectedVariants': selectedVariants.map((v) => v.toJson()).toList(),
      'selectedAdditions': selectedAdditions.map((a) => a.toJson()).toList(),
      'notes': notes,
      'quantity': quantity,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      product: ProductModel.fromJson(json['product']),
      selectedVariants: (json['selectedVariants'] as List)
          .map((v) => SelectedVariant.fromJson(v))
          .toList(),
      selectedAdditions: (json['selectedAdditions'] as List)
          .map((a) => SelectedAddition.fromJson(a))
          .toList(),
      notes: json['notes'],
      quantity: json['quantity'],
    );
  }

  @override
  String toString() {
    return 'TransactionModel{product: $product, selectedVariants: $selectedVariants, selectedAdditions: $selectedAdditions, notes: $notes, quantity: $quantity}';
  }
}
