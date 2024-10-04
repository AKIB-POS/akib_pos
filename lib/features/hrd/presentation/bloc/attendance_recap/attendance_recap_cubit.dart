import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attenddance_recap.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceRecapCubit extends Cubit<AttendanceRecapState> {
  final HRDRepository repository;

  AttendanceRecapCubit(this.repository) : super(AttendanceRecapInitial());

  Future<void> fetchAttendanceRecap({
    required int branchId,
    required int employeeId, // Added employeeId here
    required String date,
  }) async {
    emit(AttendanceRecapLoading());

    final result = await repository.getAttendanceRecap(branchId, employeeId, date);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(AttendanceRecapError(failure.message));
        } else {
          emit(AttendanceRecapError('Failed to fetch attendance recap.'));
        }
      },
      (attendanceRecap) {
        emit(AttendanceRecapLoaded(attendanceRecap));
      },
    );
  }
}


abstract class AttendanceRecapState {
  get attendanceSummary => null;
}

class AttendanceRecapInitial extends AttendanceRecapState {}

class AttendanceRecapLoading extends AttendanceRecapState {}

class AttendanceRecapLoaded extends AttendanceRecapState {
  final AttendanceRecap attendanceRecap;

  AttendanceRecapLoaded(this.attendanceRecap);
}

class AttendanceRecapError extends AttendanceRecapState {
  final String message;

  AttendanceRecapError(this.message);
}
