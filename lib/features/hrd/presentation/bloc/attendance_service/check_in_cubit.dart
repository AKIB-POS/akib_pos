import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/check_in_out_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// CheckInCubit
class CheckInCubit extends Cubit<CheckInState> {
  final HRDRepository repository;

  CheckInCubit(this.repository) : super(CheckInInitial());

  Future<void> checkIn(CheckInOutRequest request) async {
    emit(CheckInLoading());

    final result = await repository.checkIn(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(CheckInError(failure.message));
        } else {
          emit(CheckInError('Failed to check in.'));
        }
      },
      (response) {
        emit(CheckInSuccess(response.message));
      },
    );
  }
}

abstract class CheckInState {}

class CheckInInitial extends CheckInState {}

class CheckInLoading extends CheckInState {}

class CheckInSuccess extends CheckInState {
  final String message;

  CheckInSuccess(this.message);
}

class CheckInError extends CheckInState {
  final String message;

  CheckInError(this.message);
}