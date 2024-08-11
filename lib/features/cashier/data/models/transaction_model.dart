import 'package:akib_pos/features/cashier/data/models/product_model.dart';

class TransactionModel {
  final ProductModel product;
  final Map<String, String>? selectedVariants;
  final Map<String, List<String>>? selectedAdditions;// Key: sub_addition_type, Value: List of option names
  final String notes;
  final int quantity;

  TransactionModel({
    required this.product,
    required this.selectedVariants,
    required this.selectedAdditions,
    required this.notes,
    required this.quantity,
  });

  @override
  String toString() {
    return 'TransactionModel(product: ${product.name}, price: ${product.price}, selectedVariants: $selectedVariants, selectedAdditions: $selectedAdditions, notes: $notes, quantity: $quantity)';
  }
}
