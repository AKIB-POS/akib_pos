import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/submit_overtime.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitOvertimeRequestCubit extends Cubit<SubmitOvertimeRequestState> {
  final HRDRepository repository;

  SubmitOvertimeRequestCubit(this.repository) : super(SubmitOvertimeRequestInitial());

  Future<void> submitOvertimeRequest(SubmitOvertimeRequest request) async {
    emit(SubmitOvertimeRequestLoading());

    final result = await repository.submitOvertimeRequest(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(SubmitOvertimeRequestError(failure.message));
        } else {
          emit(SubmitOvertimeRequestError('Failed to submit overtime request.'));
        }
      },
      (_) {
        emit(SubmitOvertimeRequestSuccess('Permohonan lembur berhasil dibuat.'));
      },
    );
  }
}
abstract class SubmitOvertimeRequestState {}

class SubmitOvertimeRequestInitial extends SubmitOvertimeRequestState {}

class SubmitOvertimeRequestLoading extends SubmitOvertimeRequestState {}

class SubmitOvertimeRequestSuccess extends SubmitOvertimeRequestState {
  final String message;

  SubmitOvertimeRequestSuccess(this.message);
}

class SubmitOvertimeRequestError extends SubmitOvertimeRequestState {
  final String message;

  SubmitOvertimeRequestError(this.message);
}
