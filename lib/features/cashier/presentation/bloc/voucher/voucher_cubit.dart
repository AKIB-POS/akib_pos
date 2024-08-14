import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/cashier/data/models/redeem_voucher_response.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'voucher_state.dart';

class VoucherCubit extends Cubit<VoucherState> {
  final KasirRepository repository;

  VoucherCubit(this.repository) : super(VoucherInitial());

  void redeemVoucher(String code) async {
    emit(VoucherLoading());
    final result = await repository.redeemVoucher(code);
    result.fold(
      (failure) async {
        emit(VoucherError(_mapFailureToMessage(failure)));
      },
      (voucher) => emit(VoucherLoaded(voucher)),
    );
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      case NetworkFailure:
        return 'Network Failure';
      default:
        return 'Unexpected Error';
    }
  }
}

