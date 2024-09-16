import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_history_item.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  final HRDRepository repository;

  AttendanceHistoryCubit(this.repository) : super(AttendanceHistoryInitial());

  Future<void> fetchAttendanceHistory() async { // No parameters required
    emit(AttendanceHistoryLoading());

    final result = await repository.getAttendanceHistory();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(AttendanceHistoryError(failure.message));
        } else {
          emit(AttendanceHistoryError('Failed to fetch attendance history.'));
        }
      },
      (attendanceHistory) {
        emit(AttendanceHistoryLoaded(attendanceHistory));
      },
    );
  }
}

abstract class AttendanceHistoryState {}

class AttendanceHistoryInitial extends AttendanceHistoryState {}

class AttendanceHistoryLoading extends AttendanceHistoryState {}

class AttendanceHistoryLoaded extends AttendanceHistoryState {
  final AttendanceHistoryResponse attendanceHistory;

  AttendanceHistoryLoaded(this.attendanceHistory);
}

class AttendanceHistoryError extends AttendanceHistoryState {
  final String message;

  AttendanceHistoryError(this.message);
}

