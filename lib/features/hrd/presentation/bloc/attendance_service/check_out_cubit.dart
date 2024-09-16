// CheckOutCubit
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/check_in_out_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  final HRDRepository repository;

  CheckOutCubit(this.repository) : super(CheckOutInitial());

  Future<void> checkOut(CheckInOutRequest request) async {
    emit(CheckOutLoading());

    final result = await repository.checkOut(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(CheckOutError(failure.message));
        } else {
          emit(CheckOutError('Failed to check out.'));
        }
      },
      (response) {
        emit(CheckOutSuccess(response.message));
      },
    );
  }
}

abstract class CheckOutState {}

class CheckOutInitial extends CheckOutState {}

class CheckOutLoading extends CheckOutState {}

class CheckOutSuccess extends CheckOutState {
  final String message;

  CheckOutSuccess(this.message);
}

class CheckOutError extends CheckOutState {
  final String message;

  CheckOutError(this.message);
}