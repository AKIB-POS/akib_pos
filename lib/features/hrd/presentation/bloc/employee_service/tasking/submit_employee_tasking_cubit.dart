import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/submit_employee_tasking_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitEmployeeTaskingCubit extends Cubit<SubmitEmployeeTaskingState> {
  final HRDRepository repository;

  SubmitEmployeeTaskingCubit(this.repository) : super(SubmitEmployeeTaskingInitial());

  Future<void> submitEmployeeTasking(SubmitEmployeeTaskingRequest request) async {
    emit(SubmitEmployeeTaskingLoading());

    final result = await repository.submitEmployeeTasking(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(SubmitEmployeeTaskingError(failure.message));
        } else {
          emit(SubmitEmployeeTaskingError('Failed to submit employee tasking.'));
        }
      },
      (_) => emit(SubmitEmployeeTaskingSuccess('Tasking berhasil dikirim')),
    );
  }
}

abstract class SubmitEmployeeTaskingState {}

class SubmitEmployeeTaskingInitial extends SubmitEmployeeTaskingState {}

class SubmitEmployeeTaskingLoading extends SubmitEmployeeTaskingState {}

class SubmitEmployeeTaskingSuccess extends SubmitEmployeeTaskingState {
  final String message;

  SubmitEmployeeTaskingSuccess(this.message);
}

class SubmitEmployeeTaskingError extends SubmitEmployeeTaskingState {
  final String message;

  SubmitEmployeeTaskingError(this.message);
}

