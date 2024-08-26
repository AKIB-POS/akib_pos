import 'package:akib_pos/features/cashier/data/models/full_transaction_model.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final KasirRepository repository;

  CheckoutCubit(this.repository) : super(CheckoutInitial());

  Future<void> processPayment(FullTransactionModel transaction) async {
    emit(CheckoutLoading());

    final result = await repository.postTransaction(transaction);

    result.fold(
      (failure) => emit(CheckoutFailure('Failed to save transaction: $failure')),
      (_) => emit(CheckoutSuccess(transaction)),
    );
  }

  void resetCheckout() {
    emit(CheckoutInitial());
  }
}