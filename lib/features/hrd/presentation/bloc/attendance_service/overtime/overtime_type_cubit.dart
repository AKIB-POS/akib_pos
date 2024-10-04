import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_type.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OvertimeTypeCubit extends Cubit<OvertimeTypeState> {
  final HRDRepository repository;

  OvertimeTypeCubit(this.repository) : super(OvertimeTypeInitial());

  Future<void> fetchOvertimeTypes() async {
    emit(OvertimeTypeLoading());

    final result = await repository.getOvertimeTypes();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(OvertimeTypeError(failure.message));
        } else {
          emit(OvertimeTypeError('Failed to fetch overtime types.'));
        }
      },
      (overtimeTypes) {
        emit(OvertimeTypeLoaded(overtimeTypes));
      },
    );
  }
}
abstract class OvertimeTypeState {}

class OvertimeTypeInitial extends OvertimeTypeState {}

class OvertimeTypeLoading extends OvertimeTypeState {}

class OvertimeTypeLoaded extends OvertimeTypeState {
  final List<OvertimeType> overtimeTypes;

  OvertimeTypeLoaded(this.overtimeTypes);
}

class OvertimeTypeError extends OvertimeTypeState {
  final String message;

  OvertimeTypeError(this.message);
}

