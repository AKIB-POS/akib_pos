import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/employee_tasking.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeTaskCubit extends Cubit<EmployeeTaskState> {
  final HRDRepository repository;

  EmployeeTaskCubit(this.repository) : super(EmployeeTaskInitial());

  Future<void> fetchEmployeeTasks() async {
    emit(EmployeeTaskLoading());

    final result = await repository.fetchEmployeeTasks();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(EmployeeTaskError(failure.message));
        } else {
          emit(const EmployeeTaskError('Failed to fetch tasks.'));
        }
      },
      (tasks) {
        emit(EmployeeTaskLoaded(tasks));
      },
    );
  }
}

abstract class EmployeeTaskState extends Equatable {
  const EmployeeTaskState();

  @override
  List<Object?> get props => [];
}

class EmployeeTaskInitial extends EmployeeTaskState {}

class EmployeeTaskLoading extends EmployeeTaskState {}

class EmployeeTaskLoaded extends EmployeeTaskState {
  final List<EmployeeTask> tasks;

  const EmployeeTaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class EmployeeTaskError extends EmployeeTaskState {
  final String message;

  const EmployeeTaskError(this.message);

  @override
  List<Object?> get props => [message];
}