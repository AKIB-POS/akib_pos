
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/permanent_submission_detail_model.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermanentSubmissionCubit extends Cubit<PermanentSubmissionState> {
  final HRDRepository repository;

  PermanentSubmissionCubit(this.repository) : super(PermanentSubmissionInitial());

  Future<void> fetchPermanentSubmissionDetail(int candidateSubmissionId) async {
    emit(PermanentSubmissionLoading());

    final result = await repository.getPermanentSubmissionDetail(candidateSubmissionId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(PermanentSubmissionError(failure.message));
        } else {
          emit(PermanentSubmissionError('Failed to fetch permanent submission detail.'));
        }
      },
      (permanentSubmissionDetail) {
        emit(PermanentSubmissionLoaded(permanentSubmissionDetail));
      },
    );
  }
}

abstract class PermanentSubmissionState {}

class PermanentSubmissionInitial extends PermanentSubmissionState {}

class PermanentSubmissionLoading extends PermanentSubmissionState {}

class PermanentSubmissionLoaded extends PermanentSubmissionState {
  final PermanentSubmissionDetail permanentSubmissionDetail;

  PermanentSubmissionLoaded(this.permanentSubmissionDetail);
}

class PermanentSubmissionError extends PermanentSubmissionState {
  final String message;

  PermanentSubmissionError(this.message);
}
