import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/tax_management_and_tax_services/tax_charge_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaxManagementCubit extends Cubit<TaxManagementState> {
  final AccountingRepository repository;

  TaxManagementCubit({required this.repository}) : super(TaxManagementInitial());

  Future<void> fetchTaxCharge(int branchId, int companyId) async {
    try {
      emit(TaxManagementLoading());
      final result = await repository.getTaxCharge(
        branchId: branchId,
        companyId: companyId,
      );
      result.fold(
        (failure) => emit(TaxManagementError(_mapFailureToMessage(failure))),
        (taxCharge) => emit(TaxManagementLoaded(taxCharge)),
      );
    } catch (e) {
      emit(TaxManagementError(e.toString())); // Handle unexpected errors
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
abstract class TaxManagementState {}

class TaxManagementInitial extends TaxManagementState {}

class TaxManagementLoading extends TaxManagementState {}

class TaxManagementLoaded extends TaxManagementState {
  final TaxChargeModel taxCharge;

  TaxManagementLoaded(this.taxCharge);
}

class TaxManagementError extends TaxManagementState {
  final String message;

  TaxManagementError(this.message);
}
