import 'package:akib_pos/features/hrd/data/models/candidate_submission.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateApprovedSubmissionsCubit extends Cubit<CandidateApprovedSubmissionsState> {
  final HRDRepository repository;

  CandidateApprovedSubmissionsCubit(this.repository) : super(CandidateApprovedSubmissionsInitial());

  Future<void> fetchApprovedSubmissions({required int branchId}) async {
    emit(CandidateApprovedSubmissionsLoading());

    final result = await repository.getCandidateSubmissionsApproved(branchId);

    result.fold(
      (failure) {
        emit(CandidateApprovedSubmissionsError(failure.toString()));
      },
      (submissions) {
        emit(CandidateApprovedSubmissionsLoaded(submissions));
      },
    );
  }
}

abstract class CandidateApprovedSubmissionsState {}

class CandidateApprovedSubmissionsInitial extends CandidateApprovedSubmissionsState {}

class CandidateApprovedSubmissionsLoading extends CandidateApprovedSubmissionsState {}

class CandidateApprovedSubmissionsLoaded extends CandidateApprovedSubmissionsState {
  final List<CandidateSubmission> approvedSubmissions;

  CandidateApprovedSubmissionsLoaded(this.approvedSubmissions);
}

class CandidateApprovedSubmissionsError extends CandidateApprovedSubmissionsState {
  final String message;

  CandidateApprovedSubmissionsError(this.message);
}
