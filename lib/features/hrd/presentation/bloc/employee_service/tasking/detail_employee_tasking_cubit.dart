import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/detail_employee_task_response.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailEmployeeTaskCubit extends Cubit<DetailEmployeeTaskState> {
  final HRDRepository repository;

  DetailEmployeeTaskCubit(this.repository) : super(DetailEmployeeTaskInitial());

  Future<void> fetchDetailEmployeeTask(int taskingId) async {
    emit(DetailEmployeeTaskLoading());

    final result = await repository.getDetailEmployeeTask(taskingId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(DetailEmployeeTaskError(failure.message));
        } else {
          emit(DetailEmployeeTaskError('Failed to fetch employee task detail.'));
        }
      },
      (detailEmployeeTask) {
        emit(DetailEmployeeTaskLoaded(detailEmployeeTask));
      },
    );
  }
}

abstract class DetailEmployeeTaskState {}

class DetailEmployeeTaskInitial extends DetailEmployeeTaskState {}

class DetailEmployeeTaskLoading extends DetailEmployeeTaskState {}

class DetailEmployeeTaskLoaded extends DetailEmployeeTaskState {
  final DetailEmployeeTaskResponse detailEmployeeTask;

  DetailEmployeeTaskLoaded(this.detailEmployeeTask);
}

class DetailEmployeeTaskError extends DetailEmployeeTaskState {
  final String message;

  DetailEmployeeTaskError(this.message);
}
