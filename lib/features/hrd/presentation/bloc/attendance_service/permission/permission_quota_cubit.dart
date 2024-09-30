import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_quota.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionQuotaCubit extends Cubit<PermissionQuotaState> {
  final HRDRepository repository;

  PermissionQuotaCubit(this.repository) : super(PermissionQuotaInitial());

  Future<void> fetchPermissionQuota() async {
    emit(PermissionQuotaLoading());

    final result = await repository.getPermissionQuota();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(PermissionQuotaError(failure.message));
        } else {
          emit(PermissionQuotaError('Failed to fetch permission quota.'));
        }
      },
      (permissionQuota) {
        emit(PermissionQuotaLoaded(permissionQuota));
      },
    );
  }
}

abstract class PermissionQuotaState {}

class PermissionQuotaInitial extends PermissionQuotaState {}

class PermissionQuotaLoading extends PermissionQuotaState {}

class PermissionQuotaLoaded extends PermissionQuotaState {
  final PermissionQuotaResponse permissionQuota;

  PermissionQuotaLoaded(this.permissionQuota);
}

class PermissionQuotaError extends PermissionQuotaState {
  final String message;

  PermissionQuotaError(this.message);
}
