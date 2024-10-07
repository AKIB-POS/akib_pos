import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_quota.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveQuotaCubit extends Cubit<LeaveQuotaState> {
  final HRDRepository repository;

  LeaveQuotaCubit(this.repository) : super(LeaveQuotaInitial());

  Future<void> fetchLeaveQuota() async {
    emit(LeaveQuotaLoading());

    final result = await repository.getLeaveQuota();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(LeaveQuotaError(failure.message));
        } else {
          emit(LeaveQuotaError('Failed to fetch leave quota.'));
        }
      },
      (leaveQuota) {
        emit(LeaveQuotaLoaded(leaveQuota));
      },
    );
  }
}

abstract class LeaveQuotaState {}

class LeaveQuotaInitial extends LeaveQuotaState {}

class LeaveQuotaLoading extends LeaveQuotaState {}

class LeaveQuotaLoaded extends LeaveQuotaState {
  final LeaveQuotaResponse leaveQuota;

  LeaveQuotaLoaded(this.leaveQuota);
}

class LeaveQuotaError extends LeaveQuotaState {
  final String message;

  LeaveQuotaError(this.message);
}

