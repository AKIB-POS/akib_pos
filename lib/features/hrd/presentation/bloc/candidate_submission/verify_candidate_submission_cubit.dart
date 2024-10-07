import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/verify_candidate_submission_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCandidateSubmissionCubit extends Cubit<VerifyCandidateSubmissionState> {
  final HRDRepository repository;

  VerifyCandidateSubmissionCubit(this.repository) : super(VerifyCandidateSubmissionInitial());

  Future<void> verifySubmission(VerifyCandidateSubmissionRequest request) async {
    emit(VerifyCandidateSubmissionLoading());

    final result = await repository.verifyCandidateSubmission(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(VerifyCandidateSubmissionError(failure.message));
        } else {
          emit(VerifyCandidateSubmissionError('Failed to verify submission.'));
        }
      },
      (_) {
        emit(VerifyCandidateSubmissionSuccess('Submission verified successfully!'));
      },
    );
  }
}

abstract class VerifyCandidateSubmissionState {}

class VerifyCandidateSubmissionInitial extends VerifyCandidateSubmissionState {}

class VerifyCandidateSubmissionLoading extends VerifyCandidateSubmissionState {}

class VerifyCandidateSubmissionSuccess extends VerifyCandidateSubmissionState {
  final String message;
  VerifyCandidateSubmissionSuccess(this.message);
}

class VerifyCandidateSubmissionError extends VerifyCandidateSubmissionState {
  final String message;
  VerifyCandidateSubmissionError(this.message);
}
