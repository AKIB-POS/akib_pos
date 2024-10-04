import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OvertimeRequestCubit extends Cubit<OvertimeRequestState> {
  final HRDRepository repository;

  OvertimeRequestCubit(this.repository) : super(OvertimeRequestInitial());

  Future<void> fetchOvertimeRequests() async {
    emit(OvertimeRequestLoading());

    final result = await repository.getOvertimeRequests();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(OvertimeRequestError(failure.message));
        } else {
          emit(OvertimeRequestError('Failed to fetch overtime requests.'));
        }
      },
      (overtimeRequests) {
        emit(OvertimeRequestLoaded(overtimeRequests));
      },
    );
  }
}


abstract class OvertimeRequestState {}

class OvertimeRequestInitial extends OvertimeRequestState {}

class OvertimeRequestLoading extends OvertimeRequestState {}

class OvertimeRequestLoaded extends OvertimeRequestState {
  final OvertimeRequestResponse overtimeRequests;

  OvertimeRequestLoaded(this.overtimeRequests);
}

class OvertimeRequestError extends OvertimeRequestState {
  final String message;

  OvertimeRequestError(this.message);
}
