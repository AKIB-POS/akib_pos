import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/candidate_submission.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidatePendingSubmissionsCubit extends Cubit<CandidatePendingSubmissionsState> {
  final HRDRepository repository;

  CandidatePendingSubmissionsCubit(this.repository) : super(CandidatePendingSubmissionsInitial());

  Future<void> fetchPendingSubmissions({required int branchId}) async {
    emit(CandidatePendingSubmissionsLoading());

    final result = await repository.getCandidateSubmissionsPending(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(CandidatePendingSubmissionsError(failure.message));
        } else {
          emit(CandidatePendingSubmissionsError('Failed to fetch pending submissions.'));
        }
      },
      (pendingSubmissions) {
        emit(CandidatePendingSubmissionsLoaded(pendingSubmissions));
      },
    );
  }
}

abstract class CandidatePendingSubmissionsState {}

class CandidatePendingSubmissionsInitial extends CandidatePendingSubmissionsState {}

class CandidatePendingSubmissionsLoading extends CandidatePendingSubmissionsState {}

class CandidatePendingSubmissionsLoaded extends CandidatePendingSubmissionsState {
  final List<CandidateSubmission> pendingSubmissions;

  CandidatePendingSubmissionsLoaded(this.pendingSubmissions);
}

class CandidatePendingSubmissionsError extends CandidatePendingSubmissionsState {
  final String message;

  CandidatePendingSubmissionsError(this.message);
}
