import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/submission.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApprovedSubmissionsCubit extends Cubit<ApprovedSubmissionsState> {
  final HRDRepository repository;

  ApprovedSubmissionsCubit(this.repository) : super(ApprovedSubmissionsInitial());

  Future<void> fetchApprovedSubmissions({required int branchId}) async {
    emit(ApprovedSubmissionsLoading());

    final result = await repository.getApprovedSubmissions(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(ApprovedSubmissionsError(failure.message));
        } else {
          emit(ApprovedSubmissionsError('Failed to fetch approved submissions.'));
        }
      },
      (approvedSubmissions) {
        emit(ApprovedSubmissionsLoaded(approvedSubmissions));
      },
    );
  }
}

abstract class ApprovedSubmissionsState {}

class ApprovedSubmissionsInitial extends ApprovedSubmissionsState {}

class ApprovedSubmissionsLoading extends ApprovedSubmissionsState {}

class ApprovedSubmissionsLoaded extends ApprovedSubmissionsState {
  final List<EmployeeSubmission> approvedSubmissions;

  ApprovedSubmissionsLoaded(this.approvedSubmissions);
}

class ApprovedSubmissionsError extends ApprovedSubmissionsState {
  final String message;

  ApprovedSubmissionsError(this.message);
}

