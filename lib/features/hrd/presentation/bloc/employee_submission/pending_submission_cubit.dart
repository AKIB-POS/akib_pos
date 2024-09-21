import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/submission.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class PendingSubmissionsCubit extends Cubit<PendingSubmissionsState> {
  final HRDRepository repository;

  PendingSubmissionsCubit(this.repository) : super(PendingSubmissionsInitial());

  Future<void> fetchPendingSubmissions({required int branchId}) async {
    emit(PendingSubmissionsLoading());

    final result = await repository.getPendingSubmissions(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(PendingSubmissionsError(failure.message));
        } else {
          emit(PendingSubmissionsError('Failed to fetch pending submissions.'));
        }
      },
      (pendingSubmissions) {
        emit(PendingSubmissionsLoaded(pendingSubmissions));
      },
    );
  }
}


  abstract class PendingSubmissionsState {}

class PendingSubmissionsInitial extends PendingSubmissionsState {}

class PendingSubmissionsLoading extends PendingSubmissionsState {}

class PendingSubmissionsLoaded extends PendingSubmissionsState {
  final List<Submission> submissions;
  PendingSubmissionsLoaded(this.submissions);
}

class PendingSubmissionsError extends PendingSubmissionsState {
  final String message;
  PendingSubmissionsError(this.message);
}