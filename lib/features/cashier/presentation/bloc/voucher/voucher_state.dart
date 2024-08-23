part of 'voucher_cubit.dart';

abstract class VoucherState extends Equatable {
  const VoucherState();

  @override
  List<Object> get props => [];
}

class VoucherInitial extends VoucherState {}

class VoucherLoading extends VoucherState {}

class VoucherLoaded extends VoucherState {
  final RedeemVoucherResponse voucher;

  const VoucherLoaded(this.voucher);

  @override
  List<Object> get props => [voucher];
}

class VoucherError extends VoucherState {
  final String message;

  const VoucherError(this.message);

  @override
  List<Object> get props => [message];
}
