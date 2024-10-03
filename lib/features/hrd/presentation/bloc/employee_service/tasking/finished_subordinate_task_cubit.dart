import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_tasking_model.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinishedSubordinateTaskCubit extends Cubit<FinishedSubordinateTaskState> {
  final HRDRepository repository;

  FinishedSubordinateTaskCubit(this.repository) : super(FinishedSubordinateTaskInitial());

  Future<void> fetchFinishedSubordinateTasks({
    required int branchId,
  }) async {
    emit(FinishedSubordinateTaskLoading());

    final result = await repository.getSubordinateTasks(
      branchId: branchId,
      status: 'FINISHED',
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(FinishedSubordinateTaskError(failure.message));
        } else {
          emit(FinishedSubordinateTaskError('Failed to fetch finished tasks.'));
        }
      },
      (tasks) {
        emit(FinishedSubordinateTaskLoaded(tasks));
      },
    );
  }
}

abstract class FinishedSubordinateTaskState extends Equatable {
  const FinishedSubordinateTaskState();

  @override
  List<Object?> get props => [];
}

class FinishedSubordinateTaskInitial extends FinishedSubordinateTaskState {}

class FinishedSubordinateTaskLoading extends FinishedSubordinateTaskState {}

class FinishedSubordinateTaskLoaded extends FinishedSubordinateTaskState {
  final List<SubordinateTaskModel> tasks;

  const FinishedSubordinateTaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class FinishedSubordinateTaskError extends FinishedSubordinateTaskState {
  final String message;

  const FinishedSubordinateTaskError(this.message);

  @override
  List<Object?> get props => [message];
}
