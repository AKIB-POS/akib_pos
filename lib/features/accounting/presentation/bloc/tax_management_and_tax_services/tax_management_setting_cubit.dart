import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaxManagementSettingCubit extends Cubit<TaxManagementSettingState> {
  final AccountingRepository repository;

  TaxManagementSettingCubit({required this.repository})
      : super(TaxManagementSettingInitial());

  Future<void> setTaxCharge({
    required int branchId,
    required int companyId,
    required double amount,
  }) async {
    try {
      emit(TaxManagementSettingLoading());
      final result = await repository.setTaxCharge(
        branchId: branchId,
        companyId: companyId,
        amount: amount,
      );
      result.fold(
        (failure) => emit(TaxManagementSettingError(_mapFailureToMessage(failure))),
        (_) => emit(TaxManagementSettingSuccess('Berhasil Mengatur Pajak')),
      );
    } catch (e) {
      emit(TaxManagementSettingError(e.toString()));
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
abstract class TaxManagementSettingState {}

class TaxManagementSettingInitial extends TaxManagementSettingState {}

class TaxManagementSettingLoading extends TaxManagementSettingState {}

class TaxManagementSettingSuccess extends TaxManagementSettingState {
  final String message;

  TaxManagementSettingSuccess(this.message);
}

class TaxManagementSettingError extends TaxManagementSettingState {
  final String message;

  TaxManagementSettingError(this.message);
}
