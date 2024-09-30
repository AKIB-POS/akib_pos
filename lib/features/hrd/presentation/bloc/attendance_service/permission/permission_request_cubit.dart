import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_request.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionRequestCubit extends Cubit<PermissionRequestState> {
  final HRDRepository repository;

  PermissionRequestCubit(this.repository) : super(PermissionRequestInitial());

  Future<void> fetchPermissionRequests() async {
    emit(PermissionRequestLoading());

    final result = await repository.getPermissionRequests();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(PermissionRequestError(failure.message));
        } else {
          emit(PermissionRequestError('Failed to fetch permission requests.'));
        }
      },
      (permissionRequests) {
        emit(PermissionRequestLoaded(permissionRequests));
      },
    );
  }
}

abstract class PermissionRequestState {}

class PermissionRequestInitial extends PermissionRequestState {}

class PermissionRequestLoading extends PermissionRequestState {}

class PermissionRequestLoaded extends PermissionRequestState {
  final PermissionRequestResponse permissionRequest;

  PermissionRequestLoaded(this.permissionRequest);
}

class PermissionRequestError extends PermissionRequestState {
  final String message;

  PermissionRequestError(this.message);
}
