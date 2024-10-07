import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/submission/employee/verify_employee_submission_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmployeeSubmissionCubit extends Cubit<VerifyEmployeeSubmissionState> {
  final HRDRepository repository;

  VerifyEmployeeSubmissionCubit(this.repository) : super(VerifyEmployeeSubmissionInitial());

  Future<void> verifyEmployeeSubmission(VerifyEmployeeSubmissionRequest request) async {
    emit(VerifyEmployeeSubmissionLoading());

    final result = await repository.verifyEmployeeSubmission(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(VerifyEmployeeSubmissionError(failure.message));
        } else {
          emit(VerifyEmployeeSubmissionError('Failed to verify submission.'));
        }
      },
      (response) {
        emit(VerifyEmployeeSubmissionSuccess(response.message));
      },
    );
  }
}

abstract class VerifyEmployeeSubmissionState {}

class VerifyEmployeeSubmissionInitial extends VerifyEmployeeSubmissionState {}

class VerifyEmployeeSubmissionLoading extends VerifyEmployeeSubmissionState {}

class VerifyEmployeeSubmissionSuccess extends VerifyEmployeeSubmissionState {
  final String message;

  VerifyEmployeeSubmissionSuccess(this.message);
}

class VerifyEmployeeSubmissionError extends VerifyEmployeeSubmissionState {
  final String message;

  VerifyEmployeeSubmissionError(this.message);
}
