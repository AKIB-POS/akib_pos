import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_request_data.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveRequestCubit extends Cubit<LeaveRequestState> {
  final HRDRepository repository;

  LeaveRequestCubit(this.repository) : super(LeaveRequestInitial());

  Future<void> fetchLeaveRequests() async {
    emit(LeaveRequestLoading());

    final result = await repository.getLeaveRequests();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(LeaveRequestError(failure.message));
        } else {
          emit(LeaveRequestError('Failed to fetch leave requests.'));
        }
      },
      (leaveRequests) {
        emit(LeaveRequestLoaded(leaveRequests));
      },
    );
  }
}

abstract class LeaveRequestState {}

class LeaveRequestInitial extends LeaveRequestState {}

class LeaveRequestLoading extends LeaveRequestState {}

class LeaveRequestLoaded extends LeaveRequestState {
  final LeaveRequestResponse leaveRequests;

  LeaveRequestLoaded(this.leaveRequests);
}

class LeaveRequestError extends LeaveRequestState {
  final String message;

  LeaveRequestError(this.message);
}

