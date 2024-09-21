import 'package:akib_pos/features/hrd/data/models/candidate_submission.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateRejectedSubmissionsCubit extends Cubit<CandidateRejectedSubmissionsState> {
  final HRDRepository repository;

  CandidateRejectedSubmissionsCubit(this.repository) : super(CandidateRejectedSubmissionsInitial());

  Future<void> fetchRejectedSubmissions({required int branchId}) async {
    emit(CandidateRejectedSubmissionsLoading());

    final result = await repository.getCandidateSubmissionsRejected(branchId);

    result.fold(
      (failure) {
        emit(CandidateRejectedSubmissionsError(failure.toString()));
      },
      (submissions) {
        emit(CandidateRejectedSubmissionsLoaded(submissions));
      },
    );
  }
}

abstract class CandidateRejectedSubmissionsState {}

class CandidateRejectedSubmissionsInitial extends CandidateRejectedSubmissionsState {}

class CandidateRejectedSubmissionsLoading extends CandidateRejectedSubmissionsState {}

class CandidateRejectedSubmissionsLoaded extends CandidateRejectedSubmissionsState {
  final List<CandidateSubmission> rejectedSubmissions;

  CandidateRejectedSubmissionsLoaded(this.rejectedSubmissions);
}

class CandidateRejectedSubmissionsError extends CandidateRejectedSubmissionsState {
  final String message;

  CandidateRejectedSubmissionsError(this.message);
}
