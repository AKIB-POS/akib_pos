part of 'checkout_cubit.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final FullTransactionModel transaction;

  CheckoutSuccess(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class CheckoutFailure extends CheckoutState {
  final String message;

  CheckoutFailure(this.message);

  @override
  List<Object> get props => [message];
}