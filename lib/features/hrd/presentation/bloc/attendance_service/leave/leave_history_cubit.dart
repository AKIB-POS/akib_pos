import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_history.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveHistoryCubit extends Cubit<LeaveHistoryState> {
  final HRDRepository repository;

  LeaveHistoryCubit(this.repository) : super(LeaveHistoryInitial());

  Future<void> fetchLeaveHistory() async {
    emit(LeaveHistoryLoading());

    final result = await repository.getLeaveHistory();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(LeaveHistoryError(failure.message));
        } else {
          emit(LeaveHistoryError('Failed to fetch leave history.'));
        }
      },
      (leaveHistory) {
        emit(LeaveHistoryLoaded(leaveHistory));
      },
    );
  }
}

abstract class LeaveHistoryState {}

class LeaveHistoryInitial extends LeaveHistoryState {}

class LeaveHistoryLoading extends LeaveHistoryState {}

class LeaveHistoryLoaded extends LeaveHistoryState {
  final LeaveHistoryResponse leaveHistory;

  LeaveHistoryLoaded(this.leaveHistory);
}

class LeaveHistoryError extends LeaveHistoryState {
  final String message;

  LeaveHistoryError(this.message);
}

