import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_history.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OvertimeHistoryCubit extends Cubit<OvertimeHistoryState> {
  final HRDRepository repository;

  OvertimeHistoryCubit(this.repository) : super(OvertimeHistoryInitial());

  Future<void> fetchOvertimeHistory() async {
    emit(OvertimeHistoryLoading());

    final result = await repository.fetchOvertimeHistory();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(OvertimeHistoryError(failure.message));
        } else {
          emit(OvertimeHistoryError('Failed to fetch overtime history.'));
        }
      },
      (overtimeHistory) {
        emit(OvertimeHistoryLoaded(overtimeHistory));
      },
    );
  }
}


abstract class OvertimeHistoryState extends Equatable {
  const OvertimeHistoryState();

  @override
  List<Object> get props => [];
}

class OvertimeHistoryInitial extends OvertimeHistoryState {}

class OvertimeHistoryLoading extends OvertimeHistoryState {}

class OvertimeHistoryLoaded extends OvertimeHistoryState {
  final OvertimeHistoryResponse overtimeHistory;

  OvertimeHistoryLoaded(this.overtimeHistory);

  @override
  List<Object> get props => [overtimeHistory];
}

class OvertimeHistoryError extends OvertimeHistoryState {
  final String message;

  OvertimeHistoryError(this.message);

  @override
  List<Object> get props => [message];
}