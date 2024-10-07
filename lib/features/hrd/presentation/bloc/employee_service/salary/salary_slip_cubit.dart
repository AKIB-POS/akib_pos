import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/salary/salary_slip.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalarySlipCubit extends Cubit<SalarySlipState> {
  final HRDRepository repository;

  SalarySlipCubit(this.repository) : super(SalarySlipInitial());

  Future<void> fetchSalarySlips({required int year}) async {
    emit(SalarySlipLoading());

    final result = await repository.getSalarySlips(year);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(SalarySlipError(failure.message));
        } else {
          emit(SalarySlipError('Failed to fetch salary slips.'));
        }
      },
      (salarySlips) {
        emit(SalarySlipLoaded(salarySlips));
      },
    );
  }
}

abstract class SalarySlipState {}

class SalarySlipInitial extends SalarySlipState {}

class SalarySlipLoading extends SalarySlipState {}

class SalarySlipLoaded extends SalarySlipState {
  final SalarySlipsResponse salarySlips;

  SalarySlipLoaded(this.salarySlips);
}

class SalarySlipError extends SalarySlipState {
  final String message;

  SalarySlipError(this.message);
}
