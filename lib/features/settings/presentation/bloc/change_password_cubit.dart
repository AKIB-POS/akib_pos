import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/settings/data/models/change_password_request.dart';
import 'package:akib_pos/features/settings/data/repositories/setting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final SettingRepository repository;

  ChangePasswordCubit(this.repository) : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    emit(ChangePasswordLoading());

    final result = await repository.changePassword(ChangePasswordRequest(
      oldPassword: oldPassword,
      newPassword: newPassword,
      passwordConfirmation: passwordConfirmation,
    ));

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(ChangePasswordError('No Internet connection'));
        } else if (failure is GeneralFailure) {
          emit(ChangePasswordError(failure.message));
        } else {
          emit(ChangePasswordError('Failed to change password.'));
        }
      },
      (response) {
        emit(ChangePasswordSuccess(response.message));
      },
    );
  }
}

abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final String message;

  ChangePasswordSuccess(this.message);
}

class ChangePasswordError extends ChangePasswordState {
  final String message;

  ChangePasswordError(this.message);
}

