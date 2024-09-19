import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/hrd_summary.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HRDSummaryCubit extends Cubit<HRDSummaryState> {
  final HRDRepository repository;

  HRDSummaryCubit(this.repository) : super(HRDSummaryInitial());

  Future<void> fetchHRDSummary(int branchId) async {
    emit(HRDSummaryLoading());

    final result = await repository.getHRDSummary(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(HRDSummaryError(failure.message));
        } else {
          emit(HRDSummaryError('Failed to fetch HRD summary.'));
        }
      },
      (hrdSummary) {
        emit(HRDSummaryLoaded(hrdSummary));
      },
    );
  }
}

abstract class HRDSummaryState {}

class HRDSummaryInitial extends HRDSummaryState {}

class HRDSummaryLoading extends HRDSummaryState {}

class HRDSummaryLoaded extends HRDSummaryState {
  final HRDSummaryResponse hrdSummary;

  HRDSummaryLoaded(this.hrdSummary);
}

class HRDSummaryError extends HRDSummaryState {
  final String message;

  HRDSummaryError(this.message);
}
