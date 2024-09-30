import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_type.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveTypeCubit extends Cubit<LeaveTypeState> {
  final HRDRepository repository;

  LeaveTypeCubit(this.repository) : super(LeaveTypeInitial());

  Future<void> fetchLeaveTypes() async {
    emit(LeaveTypeLoading());

    final result = await repository.getLeaveTypes();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(LeaveTypeError(failure.message));
        } else {
          emit(LeaveTypeError('Failed to fetch leave types.'));
        }
      },
      (leaveTypes) {
        emit(LeaveTypeLoaded(leaveTypes));
      },
    );
  }
}

abstract class LeaveTypeState extends Equatable {
  const LeaveTypeState();

  @override
  List<Object?> get props => [];
}

class LeaveTypeInitial extends LeaveTypeState {}

class LeaveTypeLoading extends LeaveTypeState {}

class LeaveTypeLoaded extends LeaveTypeState {
  final List<LeaveType> leaveTypes;

  const LeaveTypeLoaded(this.leaveTypes);

  @override
  List<Object?> get props => [leaveTypes];
}

class LeaveTypeError extends LeaveTypeState {
  final String message;

  const LeaveTypeError(this.message);

  @override
  List<Object?> get props => [message];
}