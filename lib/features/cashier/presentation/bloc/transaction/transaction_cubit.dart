import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';

class TransactionState {
  final Map<String, String> selectedVariants;
  final Map<String, List<String>> selectedAdditions;
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
    Map<String, String>? selectedVariants,
    Map<String, List<String>>? selectedAdditions,
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
          selectedVariants: {},
          selectedAdditions: {},
          notes: '',
          quantity: 1,
          transactions: [],
        ));

  void resetState() {
    emit(TransactionState(
      selectedVariants: {},
      selectedAdditions: {},
      notes: '',
      quantity: 1,
      transactions: state.transactions,
    ));
  }

  void selectVariant(String variantType, String option) {
    final updatedVariants = Map<String, String>.from(state.selectedVariants)
      ..[variantType] = option;
    emit(state.copyWith(selectedVariants: updatedVariants));
  }

  void selectAddition(String additionType, String option) {
    final updatedAdditions = Map<String, List<String>>.from(state.selectedAdditions);
    if (updatedAdditions.containsKey(additionType)) {
      updatedAdditions[additionType]!.contains(option)
          ? updatedAdditions[additionType]!.remove(option)
          : updatedAdditions[additionType]!.add(option);
    } else {
      updatedAdditions[additionType] = [option];
    }
    emit(state.copyWith(selectedAdditions: updatedAdditions));
  }

  void updateNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  void updateQuantity(int quantity) {
    emit(state.copyWith(quantity: quantity));
  }

  void addTransaction(TransactionModel transaction) {
    final updatedTransactions = List<TransactionModel>.from(state.transactions)
      ..add(transaction);
    emit(state.copyWith(transactions: updatedTransactions));
  }

  void updateTransaction(int index, TransactionModel transaction) {
    final updatedTransactions = List<TransactionModel>.from(state.transactions)
      ..[index] = transaction;
    emit(state.copyWith(transactions: updatedTransactions));
  }

  void removeTransaction(int index) {
    final updatedTransactions = List<TransactionModel>.from(state.transactions)
      ..removeAt(index);
    emit(state.copyWith(transactions: updatedTransactions));
  }
}
