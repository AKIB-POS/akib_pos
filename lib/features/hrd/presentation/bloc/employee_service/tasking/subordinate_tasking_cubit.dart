
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_tasking_model.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubordinateTaskCubit extends Cubit<SubordinateTaskState> {
  final HRDRepository repository;

  SubordinateTaskCubit(this.repository) : super(SubordinateTaskInitial());

  Future<void> fetchSubordinateTasks({
    required int branchId,
    required String status,
  }) async {
    emit(SubordinateTaskLoading());

    final result = await repository.getSubordinateTasks(
      branchId: branchId,
      status: status,
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(SubordinateTaskError(failure.message));
        } else {
          emit(SubordinateTaskError('Failed to fetch subordinate tasks.'));
        }
      },
      (tasks) {
        emit(SubordinateTaskLoaded(tasks));
      },
    );
  }
}

abstract class SubordinateTaskState extends Equatable {
  const SubordinateTaskState();

  @override
  List<Object?> get props => [];
}

class SubordinateTaskInitial extends SubordinateTaskState {}

class SubordinateTaskLoading extends SubordinateTaskState {}

class SubordinateTaskLoaded extends SubordinateTaskState {
  final List<SubordinateTaskModel> tasks;

  const SubordinateTaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class SubordinateTaskError extends SubordinateTaskState {
  final String message;

  const SubordinateTaskError(this.message);

  @override
  List<Object?> get props => [message];
}
