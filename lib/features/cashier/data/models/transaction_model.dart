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

  @override
  String toString() {
    return 'TransactionModel{product: $product, selectedVariants: $selectedVariants, selectedAdditions: $selectedAdditions, notes: $notes, quantity: $quantity}';
  }
}