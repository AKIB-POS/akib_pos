import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/submission/employee/employee_submission.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RejectedSubmissionsCubit extends Cubit<RejectedSubmissionsState> {
  final HRDRepository repository;

  RejectedSubmissionsCubit(this.repository) : super(RejectedSubmissionsInitial());

  Future<void> fetchRejectedSubmissions({required int branchId}) async {
    emit(RejectedSubmissionsLoading());

    final result = await repository.getRejectedSubmissions(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(RejectedSubmissionsError(failure.message));
        } else {
          emit(RejectedSubmissionsError('Failed to fetch rejected submissions.'));
        }
      },
      (rejectedSubmissions) {
        emit(RejectedSubmissionsLoaded(rejectedSubmissions));
      },
    );
  }
}


abstract class RejectedSubmissionsState {}

class RejectedSubmissionsInitial extends RejectedSubmissionsState {}

class RejectedSubmissionsLoading extends RejectedSubmissionsState {}

class RejectedSubmissionsLoaded extends RejectedSubmissionsState {
  final List<EmployeeSubmission> rejectedSubmissions;

  RejectedSubmissionsLoaded(this.rejectedSubmissions);
}

class RejectedSubmissionsError extends RejectedSubmissionsState {
  final String message;

  RejectedSubmissionsError(this.message);
}
