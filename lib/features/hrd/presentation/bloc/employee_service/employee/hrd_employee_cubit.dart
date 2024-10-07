import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/hrd_all_employee.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class HRDAllEmployeesState extends Equatable {
  @override
  List<Object> get props => [];
}

class HRDAllEmployeesInitial extends HRDAllEmployeesState {}

class HRDAllEmployeesLoading extends HRDAllEmployeesState {}

class HRDAllEmployeesLoaded extends HRDAllEmployeesState {
  final List<HRDAllEmployee> employeeList;

  HRDAllEmployeesLoaded(this.employeeList);

  @override
  List<Object> get props => [employeeList];
}

class HRDAllEmployeesError extends HRDAllEmployeesState {
  final String message;

  HRDAllEmployeesError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class HRDAllEmployeesCubit extends Cubit<HRDAllEmployeesState> {
  final HRDRepository repository;

  HRDAllEmployeesCubit(this.repository) : super(HRDAllEmployeesInitial());

  Future<void> fetchAllEmployees(int branchId) async {
    emit(HRDAllEmployeesLoading());

    final result = await repository.getAllEmployees(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(HRDAllEmployeesError(failure.message));
        } else {
          emit(HRDAllEmployeesError('Failed to fetch employee list.'));
        }
      },
      (employeeList) {
        emit(HRDAllEmployeesLoaded(employeeList));
      },
    );
  }
}
