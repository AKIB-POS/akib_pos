import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_history.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionHistoryCubit extends Cubit<PermissionHistoryState> {
  final HRDRepository repository;
  PermissionHistoryCubit(this.repository) : super(PermissionHistoryInitial());

  Future<void> fetchPermissionHistory() async {
    emit(PermissionHistoryLoading());

    final result = await repository.getPermissionHistory();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(PermissionHistoryError(failure.message));
        } else {
          emit(PermissionHistoryError('Failed to fetch permission history.'));
        }
      },
      (permissionHistory) {
        emit(PermissionHistoryLoaded(permissionHistory));
      },
    );
  }
}


abstract class PermissionHistoryState {}

class PermissionHistoryInitial extends PermissionHistoryState {}

class PermissionHistoryLoading extends PermissionHistoryState {}

class PermissionHistoryLoaded extends PermissionHistoryState {
  final PermissionHistoryResponse permissionHistory;

  PermissionHistoryLoaded(this.permissionHistory);
}

class PermissionHistoryError extends PermissionHistoryState {
  final String message;

  PermissionHistoryError(this.message);
}
