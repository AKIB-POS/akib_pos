import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:akib_pos/features/auth/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login(String email, String password, bool isCashier) async {
    emit(AuthLoading());

    final result = await _authRepository.login(email, password,isCashier);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(AuthError(failure.message));
        } else {
          emit(AuthError("Failed to login"));
        }
      },
      (response) => emit(AuthLoginSuccess(response)),
    );
  }

  Future<void> register({
    required String email,
    required String username,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String companyName,
    String? companyEmail,
    required String companyPhone,
    required String companyAddress,
  }) async {
    emit(AuthLoading());

    final result = await _authRepository.register(
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      phone: phone,
      username: username,
      companyName: companyName,
      companyEmail: companyEmail ?? email,
      companyAddress: companyAddress,
      companyPhone: companyPhone,
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(AuthError(failure.message));
        } else {
          emit(AuthError("Failed to register"));
        }
      },
      (response) => emit(AuthRegisterSuccess(response)),
    );
  }
}


abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final LoginResponse loginResponse;

  const AuthLoginSuccess(this.loginResponse);

  @override
  List<Object?> get props => [loginResponse];
}

class AuthRegisterSuccess extends AuthState {
  final bool registerResponse;

  const AuthRegisterSuccess(this.registerResponse);

  @override
  List<Object?> get props => [registerResponse];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}