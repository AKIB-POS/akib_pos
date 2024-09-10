import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceChargeSettingCubit extends Cubit<ServiceChargeSettingState> {
  final AccountingRepository repository;

  ServiceChargeSettingCubit({required this.repository})
      : super(ServiceChargeSettingInitial());

  Future<void> setServiceCharge({
    required int branchId,
    required int companyId,
    required double amount,
  }) async {
    try {
      emit(ServiceChargeSettingLoading());
      final result = await repository.setServiceCharge(
        branchId: branchId,
        companyId: companyId,
        amount: amount,
      );
      result.fold(
        (failure) => emit(ServiceChargeSettingError(_mapFailureToMessage(failure))),
        (_) => emit(ServiceChargeSettingSuccess('Berhasil Mengatur Biaya Layanan')),
      );
    } catch (e) {
      emit(ServiceChargeSettingError(e.toString()));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Failure';
    } else if (failure is GeneralFailure) {
      return failure.message;
    } else {
      return 'Unexpected Error';
    }
  }
}

// States
abstract class ServiceChargeSettingState {}

class ServiceChargeSettingInitial extends ServiceChargeSettingState {}

class ServiceChargeSettingLoading extends ServiceChargeSettingState {}

class ServiceChargeSettingSuccess extends ServiceChargeSettingState {
  final String message;

  ServiceChargeSettingSuccess(this.message);
}

class ServiceChargeSettingError extends ServiceChargeSettingState {
  final String message;

  ServiceChargeSettingError(this.message);
}
