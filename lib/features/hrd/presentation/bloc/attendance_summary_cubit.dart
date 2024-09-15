import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_summary.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceSummaryCubit extends Cubit<AttendanceSummaryState> {
  final HRDRepository repository;

  AttendanceSummaryCubit(this.repository) : super(AttendanceSummaryInitial());

  Future<void> fetchAttendanceSummary({
    required int branchId,
    required int companyId,
  }) async {
    emit(AttendanceSummaryLoading());

    final result = await repository.getAttendanceSummary(branchId, companyId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(AttendanceSummaryError(failure.message));
        } else {
          emit(AttendanceSummaryError('Failed to fetch attendance summary.'));
        }
      },
      (attendanceSummary) {
        emit(AttendanceSummaryLoaded(attendanceSummary));
      },
    );
  }
}

abstract class AttendanceSummaryState {}

class AttendanceSummaryInitial extends AttendanceSummaryState {}

class AttendanceSummaryLoading extends AttendanceSummaryState {}

class AttendanceSummaryLoaded extends AttendanceSummaryState {
  final AttendanceSummaryResponse attendanceSummary;

  AttendanceSummaryLoaded(this.attendanceSummary);
}

class AttendanceSummaryError extends AttendanceSummaryState {
  final String message;

  AttendanceSummaryError(this.message);
}
