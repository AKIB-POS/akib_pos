import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/addition_option.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
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

  TransactionState({
    required this.selectedVariants,
    required this.selectedAdditions,
    required this.notes,
    required this.quantity,
    required this.transactions,
  });

  TransactionState copyWith({
    List<SelectedVariant>? selectedVariants,
    List<SelectedAddition>? selectedAdditions,
    String? notes,
    int? quantity,
    List<TransactionModel>? transactions,
  }) {
    return TransactionState(
      selectedVariants: selectedVariants ?? this.selectedVariants,
      selectedAdditions: selectedAdditions ?? this.selectedAdditions,
      notes: notes ?? this.notes,
      quantity: quantity ?? this.quantity,
      transactions: transactions ?? this.transactions,
    );
  }
}


class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit()
      : super(TransactionState(
          selectedVariants: [],
          selectedAdditions: [],
          notes: '',
          quantity: 1,
          transactions: [],
        ));

  void resetState() {
    emit(TransactionState(
      selectedVariants: [],
      selectedAdditions: [],
      notes: '',
      quantity: 1,
      transactions: state.transactions,
    ));
  }

  void selectVariant(SelectedVariant variant) {
    final updatedVariants = List<SelectedVariant>.from(state.selectedVariants)..add(variant);
    emit(state.copyWith(selectedVariants: updatedVariants));
    _updateTotalPrice();
  }

  void deselectVariant(SelectedVariant variant) {
    final updatedVariants = List<SelectedVariant>.from(state.selectedVariants)
      ..removeWhere((v) => v.name == variant.name);
    emit(state.copyWith(selectedVariants: updatedVariants));
    _updateTotalPrice(reduce: variant.price);
  }

  void selectAddition(SelectedAddition addition) {
    final updatedAdditions = List<SelectedAddition>.from(state.selectedAdditions)..add(addition);
    emit(state.copyWith(selectedAdditions: updatedAdditions));
    _updateTotalPrice();
  }

  void deselectAddition(SelectedAddition addition) {
    final updatedAdditions = List<SelectedAddition>.from(state.selectedAdditions)
      ..removeWhere((a) => a.name == addition.name);
    emit(state.copyWith(selectedAdditions: updatedAdditions));
    _updateTotalPrice(reduce: addition.price);
  }

  void updateNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  

 
  void addTransaction(TransactionModel transaction) {
    final updatedTransactions = List<TransactionModel>.from(state.transactions)..add(transaction);
    emit(state.copyWith(transactions: updatedTransactions));
    _updateTotalPrice();
  }

  void updateTransaction(int index, TransactionModel transaction) {
    final updatedTransactions = List<TransactionModel>.from(state.transactions)..[index] = transaction;
    emit(state.copyWith(transactions: updatedTransactions));
    _updateTotalPrice(index: index);
  }

  void removeTransaction(int index) {
    final updatedTransactions = List<TransactionModel>.from(state.transactions)..removeAt(index);
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
  final updatedTransaction = currentTransaction.copyWith(quantity: currentTransaction.quantity + 1);
  final updatedTransactions = List<TransactionModel>.from(state.transactions)..[index] = updatedTransaction;
  emit(state.copyWith(transactions: updatedTransactions));
  _updateTotalPrice(index: index); // Update the total price
}

void subtractQuantity(int index) {
  final currentTransaction = state.transactions[index];
  if (currentTransaction.quantity > 1) {
    final updatedTransaction = currentTransaction.copyWith(quantity: currentTransaction.quantity - 1);
    final updatedTransactions = List<TransactionModel>.from(state.transactions)..[index] = updatedTransaction;
    emit(state.copyWith(transactions: updatedTransactions));
    _updateTotalPrice(index: index); // Update the total price
  } else {
    removeTransaction(index);
  }
}



   void updateTransactionQuantity(int index, int quantity) {
    final currentTransaction = state.transactions[index];
    final newQuantity = quantity.clamp(1, 100);
    final updatedTransaction = currentTransaction.copyWith(quantity: newQuantity);
    final updatedTransactions = List<TransactionModel>.from(state.transactions)
      ..[index] = updatedTransaction;
    emit(state.copyWith(transactions: updatedTransactions));
    _updateTotalPrice(index: index);
    print("apakah update  ${updatedTransactions}");
  }


  void _updateTotalPrice({int? index, int reduce = 0}) {
    if (state.transactions.isEmpty) return;

    if (index == null) {
      print("apakah sebelum calculate ${state.quantity}  ${state.transactions}");
      final totalPrice = _calculateTotalPrice(state.quantity, state.selectedVariants, state.selectedAdditions) - reduce * state.quantity;
      print("apakah calculate $totalPrice");
      final updatedProduct = state.transactions.last.product.copyWith(totalPrice: totalPrice);
      final updatedTransaction = state.transactions.last.copyWith(product: updatedProduct);
      final updatedTransactions = List<TransactionModel>.from(state.transactions)
        ..[state.transactions.length - 1] = updatedTransaction;
      emit(state.copyWith(transactions: updatedTransactions));
    } else {
      final transaction = state.transactions[index];
      final totalPrice = _calculateTotalPrice(transaction.quantity, transaction.selectedVariants, transaction.selectedAdditions) - reduce * transaction.quantity;
      final updatedProduct = transaction.product.copyWith(totalPrice: totalPrice);
      final updatedTransaction = transaction.copyWith(product: updatedProduct);
      final updatedTransactions = List<TransactionModel>.from(state.transactions)
        ..[index] = updatedTransaction;
      emit(state.copyWith(transactions: updatedTransactions));
    }
  }

  int _calculateTotalPrice(int quantity, List<SelectedVariant> variants, List<SelectedAddition> additions) {
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

    return totalPrice;
  }
}
