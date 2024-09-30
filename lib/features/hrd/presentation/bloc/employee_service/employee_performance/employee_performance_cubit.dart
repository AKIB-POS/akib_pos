import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/employee_performance.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeePerformanceCubit extends Cubit<EmployeePerformanceState> {
  final HRDRepository repository;

  EmployeePerformanceCubit(this.repository) : super(EmployeePerformanceInitial());

  Future<void> fetchEmployeePerformance({
    required int branchId,
    required String month,
    required String year,
  }) async {
    emit(EmployeePerformanceLoading());

    final result = await repository.getEmployeePerformance(branchId, month, year);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(EmployeePerformanceError(failure.message));
        } else {
          emit(EmployeePerformanceError('Failed to fetch employee performance data.'));
        }
      },
      (employeePerformances) {
        emit(EmployeePerformanceLoaded(employeePerformances));
      },
    );
  }
}

abstract class EmployeePerformanceState extends Equatable {
  const EmployeePerformanceState();

  @override
  List<Object> get props => [];
}

class EmployeePerformanceInitial extends EmployeePerformanceState {}

class EmployeePerformanceLoading extends EmployeePerformanceState {}

class EmployeePerformanceLoaded extends EmployeePerformanceState {
  final List<EmployeePerformance> employeePerformances;

  const EmployeePerformanceLoaded(this.employeePerformances);

  @override
  List<Object> get props => [employeePerformances];
}

class EmployeePerformanceError extends EmployeePerformanceState {
  final String message;

  const EmployeePerformanceError(this.message);

  @override
  List<Object> get props => [message];
}