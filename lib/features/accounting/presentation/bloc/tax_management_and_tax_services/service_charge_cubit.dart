import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/tax_management_and_tax_services/service_charge_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceChargeCubit extends Cubit<ServiceChargeState> {
  final AccountingRepository repository;

  ServiceChargeCubit({required this.repository}) : super(ServiceChargeInitial());

  Future<void> fetchServiceCharge(int branchId, int companyId) async {
    try {
      emit(ServiceChargeLoading());
      final result = await repository.getServiceCharge(
        branchId: branchId,
        companyId: companyId,
      );
      result.fold(
        (failure) => emit(ServiceChargeError(_mapFailureToMessage(failure))),
        (serviceCharge) => emit(ServiceChargeLoaded(serviceCharge)),
      );
    } catch (e) {
      emit(ServiceChargeError(e.toString())); // Handle unexpected errors
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Failure';  // Pesan untuk kesalahan server-side
    } else if (failure is GeneralFailure) {
      return failure.message; // Ambil pesan dari GeneralFailure secara langsung
    } else {
      return 'Unexpected Error';
    }
  }
}



abstract class ServiceChargeState {}

class ServiceChargeInitial extends ServiceChargeState {}

class ServiceChargeLoading extends ServiceChargeState {}

class ServiceChargeLoaded extends ServiceChargeState {
  final ServiceChargeModel serviceCharge;

  ServiceChargeLoaded(this.serviceCharge);
}

class ServiceChargeError extends ServiceChargeState {
  final String message;

  ServiceChargeError(this.message);
}

