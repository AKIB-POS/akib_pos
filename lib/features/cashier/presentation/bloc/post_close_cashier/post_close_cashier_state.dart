part of 'post_close_cashier_cubit.dart';

abstract class PostCloseCashierState {}

class PostCloseCashierInitial extends PostCloseCashierState {}

class PostCloseCashierLoading extends PostCloseCashierState {}

class PostCloseCashierSuccess extends PostCloseCashierState {
  final String message;
  PostCloseCashierSuccess(this.message);
}

class PostCloseCashierError extends PostCloseCashierState {
  final String message;
  PostCloseCashierError(this.message);
}