import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_tasking_model.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnfinishedSubordinateTaskCubit extends Cubit<UnfinishedSubordinateTaskState> {
  final HRDRepository repository;

  UnfinishedSubordinateTaskCubit(this.repository) : super(UnfinishedSubordinateTaskInitial());

  Future<void> fetchUnfinishedSubordinateTasks({
    required int branchId,
  }) async {
    emit(UnfinishedSubordinateTaskLoading());

    final result = await repository.getSubordinateTasks(
      branchId: branchId,
      status: 'UNFINISHED',
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(UnfinishedSubordinateTaskError(failure.message));
        } else {
          emit(UnfinishedSubordinateTaskError('Failed to fetch unfinished tasks.'));
        }
      },
      (tasks) {
        emit(UnfinishedSubordinateTaskLoaded(tasks));
      },
    );
  }
}

abstract class UnfinishedSubordinateTaskState extends Equatable {
  const UnfinishedSubordinateTaskState();

  @override
  List<Object?> get props => [];
}

class UnfinishedSubordinateTaskInitial extends UnfinishedSubordinateTaskState {}

class UnfinishedSubordinateTaskLoading extends UnfinishedSubordinateTaskState {}

class UnfinishedSubordinateTaskLoaded extends UnfinishedSubordinateTaskState {
  final List<SubordinateTaskModel> tasks;

  const UnfinishedSubordinateTaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class UnfinishedSubordinateTaskError extends UnfinishedSubordinateTaskState {
  final String message;

  const UnfinishedSubordinateTaskError(this.message);

  @override
  List<Object?> get props => [message];
}
