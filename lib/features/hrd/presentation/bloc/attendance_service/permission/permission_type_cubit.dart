import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_type.dart';
import 'package:akib_pos/features/hrd/data/repositories/hrd_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionTypeCubit extends Cubit<PermissionTypeState> {
  final HRDRepository repository;

  PermissionTypeCubit(this.repository) : super(PermissionTypeInitial());

  Future<void> fetchPermissionTypes() async {
    emit(PermissionTypeLoading());

    final result = await repository.fetchPermissionTypes();

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(PermissionTypeError(failure.message));
        } else {
          emit(PermissionTypeError('Failed to fetch permission types.'));
        }
      },
      (permissionTypes) {
        emit(PermissionTypeLoaded(permissionTypes));
      },
    );
  }
}

abstract class PermissionTypeState extends Equatable {
  const PermissionTypeState();

  @override
  List<Object?> get props => [];
}

class PermissionTypeInitial extends PermissionTypeState {}

class PermissionTypeLoading extends PermissionTypeState {}

class PermissionTypeLoaded extends PermissionTypeState {
  final List<PermissionType> permissionTypes;

  const PermissionTypeLoaded(this.permissionTypes);

  @override
  List<Object?> get props => [permissionTypes];
}

class PermissionTypeError extends PermissionTypeState {
  final String message;

  const PermissionTypeError(this.message);

  @override
  List<Object?> get props => [message];
}