part of 'close_cashier_cubit.dart';

abstract class CloseCashierState {}

class CloseCashierInitial extends CloseCashierState {}

class CloseCashierLoading extends CloseCashierState {}

class CloseCashierLoaded extends CloseCashierState {
  final CloseCashierResponse response;

  CloseCashierLoaded(this.response);
}

class CloseCashierError extends CloseCashierState {
  final String message;

  CloseCashierError(this.message);
}
