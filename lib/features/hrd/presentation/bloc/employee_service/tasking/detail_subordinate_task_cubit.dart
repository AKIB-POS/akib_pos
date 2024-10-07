import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_task_detail.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailSubordinateTaskCubit extends Cubit<DetailSubordinateTaskState> {
  final HRDRepository repository;

  DetailSubordinateTaskCubit(this.repository) : super(DetailSubordinateTaskInitial());

  Future<void> fetchDetailSubordinateTask(int taskingId) async {
    emit(DetailSubordinateTaskLoading());

    final result = await repository.getDetailSubordinateTask(taskingId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(DetailSubordinateTaskError(failure.message));
        } else {
          emit(DetailSubordinateTaskError('Failed to fetch task details.'));
        }
      },
      (detail) {
        emit(DetailSubordinateTaskLoaded(detail));
      },
    );
  }
}

abstract class DetailSubordinateTaskState {}

class DetailSubordinateTaskInitial extends DetailSubordinateTaskState {}

class DetailSubordinateTaskLoading extends DetailSubordinateTaskState {}

class DetailSubordinateTaskLoaded extends DetailSubordinateTaskState {
  final SubordinateTaskDetail detail;

  DetailSubordinateTaskLoaded(this.detail);
}

class DetailSubordinateTaskError extends DetailSubordinateTaskState {
  final String message;

  DetailSubordinateTaskError(this.message);
}

