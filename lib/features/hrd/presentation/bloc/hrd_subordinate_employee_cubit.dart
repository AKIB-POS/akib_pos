import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/subordinate_employee.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HRDAllSubordinateEmployeeCubit extends Cubit<HRDAllSubordinateEmployeeState> {
  final HRDRepository repository;

  HRDAllSubordinateEmployeeCubit(this.repository) : super(HRDAllSubordinateEmployeeInitial());

  Future<void> fetchAllSubordinateEmployees({
    required int branchId,
  }) async {
    emit(HRDAllSubordinateEmployeeLoading());

    final result = await repository.getAllSubordinateEmployees(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(HRDAllSubordinateEmployeeError(failure.message));
        } else {
          emit(HRDAllSubordinateEmployeeError('Failed to fetch subordinate employees.'));
        }
      },
      (subordinateEmployees) {
        emit(HRDAllSubordinateEmployeeLoaded(subordinateEmployees));
      },
    );
  }
}


abstract class HRDAllSubordinateEmployeeState {}

class HRDAllSubordinateEmployeeInitial extends HRDAllSubordinateEmployeeState {}

class HRDAllSubordinateEmployeeLoading extends HRDAllSubordinateEmployeeState {}

class HRDAllSubordinateEmployeeLoaded extends HRDAllSubordinateEmployeeState {
  final List<SubordinateEmployeeModel> employees;

  HRDAllSubordinateEmployeeLoaded(this.employees);
}

class HRDAllSubordinateEmployeeError extends HRDAllSubordinateEmployeeState {
  final String message;

  HRDAllSubordinateEmployeeError(this.message);
}
