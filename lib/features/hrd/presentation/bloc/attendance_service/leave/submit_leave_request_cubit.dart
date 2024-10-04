import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitLeaveRequestCubit extends Cubit<SubmitLeaveRequestState> {
  final HRDRepository repository;

  SubmitLeaveRequestCubit(this.repository) : super(SubmitLeaveRequestInitial());

  Future<void> submitLeaveRequest(LeaveRequest leaveRequest) async {
    emit(SubmitLeaveRequestLoading());

    final result = await repository.submitLeaveRequest(leaveRequest);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(SubmitLeaveRequestError(failure.message));
        } else {
          emit(SubmitLeaveRequestError('Failed to submit leave request.'));
        }
      },
      (_) {
        emit(SubmitLeaveRequestSuccess());
      },
    );
  }
}

abstract class SubmitLeaveRequestState extends Equatable {
  const SubmitLeaveRequestState();

  @override
  List<Object?> get props => [];
}

class SubmitLeaveRequestInitial extends SubmitLeaveRequestState {}

class SubmitLeaveRequestLoading extends SubmitLeaveRequestState {}

class SubmitLeaveRequestSuccess extends SubmitLeaveRequestState {}

class SubmitLeaveRequestError extends SubmitLeaveRequestState {
  final String message;

  const SubmitLeaveRequestError(this.message);

  @override
  List<Object?> get props => [message];
}
