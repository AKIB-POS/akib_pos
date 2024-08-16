import 'package:akib_pos/features/cashier/data/datasources/transaction_service.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/addition_option.dart';
import 'package:akib_pos/features/cashier/data/models/full_transaction_models.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/redeem_voucher_response.dart';
import 'package:akib_pos/features/cashier/data/models/varian_option.dart';
import 'package:akib_pos/features/cashier/data/models/variant_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';

class TransactionState {
  final List<SelectedVariant> selectedVariants;
  final List<SelectedAddition> selectedAdditions;
  final String notes;
  final int quantity;
  final List<TransactionModel> transactions;
  final double discount;
  final double tax;
  final VoucherData? voucher;
  final int? customerId; // Add customer ID
  final String? customerName;
  final String? customerPhone; // Add customer name

  TransactionState({
    required this.selectedVariants,
    required this.selectedAdditions,
    required this.notes,
    required this.quantity,
    required this.transactions,
    this.discount = 0.0,
    this.tax = 0.0,
    this.voucher,
    this.customerId,
    this.customerName,
    this.customerPhone,
  });

  TransactionState copyWith({
    List<SelectedVariant>? selectedVariants,
    List<SelectedAddition>? selectedAdditions,
    String? notes,
    int? quantity,
    List<TransactionModel>? transactions,
    double? discount,
    double? tax,
    VoucherData? voucher,
    int? customerId, // Add customer ID
    String? customerName, // Add customer name
    String? customerPhone, // Add customer name
  }) {
    return TransactionState(
      selectedVariants: selectedVariants ?? this.selectedVariants,
      selectedAdditions: selectedAdditions ?? this.selectedAdditions,
      notes: notes ?? this.notes,
      quantity: quantity ?? this.quantity,
      transactions: transactions ?? this.transactions,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      voucher: voucher ?? this.voucher,
      customerId: customerId ?? this.customerId, // Assign customer ID
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone, // Assign customer name
    );
  }
}

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionService transactionService;

  TransactionCubit(this.transactionService)
      : super(TransactionState(
          selectedVariants: [],
          selectedAdditions: [],
          notes: '',
          quantity: 1,
          transactions: [],
        ));

  void updateCustomer(int customerId, String customerName, String customerPhone) {
    emit(state.copyWith(customerId: customerId, customerName: customerName,customerPhone: customerPhone));
  }

  Future<void> saveFullTransaction(
      List<TransactionModel> transactions, String notes) async {
    FullTransactionModel fullTransaction = FullTransactionModel(
        transactions: transactions, savedNotes: notes, time: DateTime.now());

    await transactionService.saveFullTransaction(fullTransaction);
    emit(state.copyWith(transactions: [],customerName: "Nama Pelanggan",customerId: null, customerPhone: null));
  }

  Future<List<FullTransactionModel>> getFullTransactions() async {
    return await transactionService.getFullTransactions();
  }

  Future<void> loadFullTransactions(
      FullTransactionModel fullTransaction) async {
    final allTransactions = fullTransaction.transactions;
    emit(state.copyWith(transactions: allTransactions));
  }

  Future<void> removeFullTransaction(
      FullTransactionModel fullTransaction) async {
    await transactionService.removeFullTransaction(fullTransaction);
    await loadFullTransactions(fullTransaction);
  }

  void updateVoucher(VoucherData? voucher) {
    emit(state.copyWith(voucher: voucher));
  }

  void resetState() {
    emit(TransactionState(
      selectedVariants: [],
      selectedAdditions: [],
      notes: '',
      quantity: 1,
      transactions: state.transactions,
      discount: state.discount,
      tax: state.tax,
    ));
  }

  void selectVariant(SelectedVariant variant) {
    // Remove any existing variant with the same subVariantType before adding the new one
    final updatedVariants = List<SelectedVariant>.from(state.selectedVariants)
      ..removeWhere((v) => v.subVariantType == variant.subVariantType)
      ..add(variant);

    emit(state.copyWith(selectedVariants: updatedVariants));
    _updateTotalPrice();
  }

  void deselectVariant(SelectedVariant variant) {
    // Remove the variant by matching the name
    final updatedVariants = List<SelectedVariant>.from(state.selectedVariants)
      ..removeWhere((v) => v.name == variant.name);

    emit(state.copyWith(selectedVariants: updatedVariants));
    _updateTotalPrice(reduce: variant.price);
  }

  void selectAddition(SelectedAddition addition) {
    final updatedAdditions =
        List<SelectedAddition>.from(state.selectedAdditions)..add(addition);
    emit(state.copyWith(selectedAdditions: updatedAdditions));
    _updateTotalPrice();
  }

  void deselectAddition(SelectedAddition addition) {
    final updatedAdditions =
        List<SelectedAddition>.from(state.selectedAdditions)
          ..removeWhere((a) => a.name == addition.name);
    emit(state.copyWith(selectedAdditions: updatedAdditions));
    _updateTotalPrice(reduce: addition.price);
  }

  void updateNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  void addTransaction(TransactionModel transaction) {
    final updatedTransactions = List<TransactionModel>.from(state.transactions)
      ..add(transaction);
    emit(state.copyWith(transactions: updatedTransactions));
    _updateTotalPrice();
  }

  void updateTransaction(int index, TransactionModel transaction) {
    final updatedTransactions = List<TransactionModel>.from(state.transactions)
      ..[index] = transaction;
    emit(state.copyWith(transactions: updatedTransactions));
    _updateTotalPrice(index: index);
  }

  void removeTransaction(int index) {
    final updatedTransactions = List<TransactionModel>.from(state.transactions)
      ..removeAt(index);
    emit(state.copyWith(transactions: updatedTransactions));
  }

  void setInitialStateForEdit(TransactionModel transaction) {
    emit(state.copyWith(
      selectedVariants: transaction.selectedVariants,
      selectedAdditions: transaction.selectedAdditions,
      notes: transaction.notes,
      quantity: transaction.quantity,
    ));
  }

  void updateQuantity(int quantity) {
    emit(state.copyWith(quantity: quantity));
    _updateTotalPrice();
  }

  void addQuantity(int index) {
    final currentTransaction = state.transactions[index];
    final updatedTransaction =
        currentTransaction.copyWith(quantity: currentTransaction.quantity + 1);
    final updatedTransactions = List<TransactionModel>.from(state.transactions)
      ..[index] = updatedTransaction;
    emit(state.copyWith(transactions: updatedTransactions));
    _updateTotalPrice(index: index); // Update the total price
  }

  void subtractQuantity(int index) {
    final currentTransaction = state.transactions[index];
    if (currentTransaction.quantity > 1) {
      final updatedTransaction = currentTransaction.copyWith(
          quantity: currentTransaction.quantity - 1);
      final updatedTransactions =
          List<TransactionModel>.from(state.transactions)
            ..[index] = updatedTransaction;
      emit(state.copyWith(transactions: updatedTransactions));
      _updateTotalPrice(index: index); // Update the total price
    } else {
      removeTransaction(index);
    }
  }

  void updateTransactionQuantity(int index, int quantity) {
    final currentTransaction = state.transactions[index];
    final newQuantity = quantity.clamp(1, 100);
    final updatedTransaction =
        currentTransaction.copyWith(quantity: newQuantity);
    final updatedTransactions = List<TransactionModel>.from(state.transactions)
      ..[index] = updatedTransaction;
    emit(state.copyWith(transactions: updatedTransactions));
    _updateTotalPrice(index: index);
  }

  void updateDiscount(double discount) {
    emit(state.copyWith(discount: discount));
    _updateTotalPrice();
  }

  void updateTax(double tax) {
    emit(state.copyWith(tax: tax));
    _updateTotalPrice();
  }

  void _updateTotalPrice({int? index, int reduce = 0}) {
    if (state.transactions.isEmpty) return;

    if (index == null) {
      final totalPrice = _calculateTotalPrice(
              state.quantity, state.selectedVariants, state.selectedAdditions) -
          reduce * state.quantity;
      final updatedProduct =
          state.transactions.last.product.copyWith(totalPrice: totalPrice);
      final updatedTransaction =
          state.transactions.last.copyWith(product: updatedProduct);
      final updatedTransactions =
          List<TransactionModel>.from(state.transactions)
            ..[state.transactions.length - 1] = updatedTransaction;
      emit(state.copyWith(transactions: updatedTransactions));
    } else {
      final transaction = state.transactions[index];
      final totalPrice = _calculateTotalPrice(transaction.quantity,
              transaction.selectedVariants, transaction.selectedAdditions) -
          reduce * transaction.quantity;
      final updatedProduct =
          transaction.product.copyWith(totalPrice: totalPrice);
      final updatedTransaction = transaction.copyWith(product: updatedProduct);
      final updatedTransactions =
          List<TransactionModel>.from(state.transactions)
            ..[index] = updatedTransaction;
      emit(state.copyWith(transactions: updatedTransactions));
    }
  }

  int _calculateTotalPrice(int quantity, List<SelectedVariant> variants,
      List<SelectedAddition> additions) {
    if (state.transactions.isEmpty) return 0;

    int totalPrice = state.transactions.last.product.price * quantity;

    // Add variant prices
    variants.forEach((variant) {
      totalPrice += variant.price * quantity;
    });

    // Add addition prices
    additions.forEach((addition) {
      totalPrice += addition.price * quantity;
    });

    // Apply voucher discount
    if (state.voucher != null) {
      if (state.voucher!.type == 'nominal') {
        totalPrice -= state.voucher!.amount.toInt();
      } else if (state.voucher!.type == 'percentage') {
        totalPrice -= (totalPrice * state.voucher!.amount / 100).toInt();
      }
    }

    return totalPrice;
  }
}
