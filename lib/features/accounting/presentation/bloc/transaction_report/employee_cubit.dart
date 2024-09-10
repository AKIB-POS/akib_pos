import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/employee.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final AccountingRepository repository;

  EmployeeCubit({required this.repository}) : super(EmployeeInitial());

  void fetchAllEmployees(int branchId, int companyId) async {
    emit(EmployeeLoading());

    final result = await repository.getAllEmployees(branchId, companyId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(EmployeeError(failure.message));
        } else {
          emit(EmployeeError('Gagal mengambil data pegawai.'));
        }
      },
      (response) {
        emit(EmployeeSuccess(response.data));
      },
    );
  }
}

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {
  final List<EmployeeModel> employees;

  EmployeeSuccess(this.employees);
}

class EmployeeError extends EmployeeState {
  final String message;

  EmployeeError(this.message);
}
