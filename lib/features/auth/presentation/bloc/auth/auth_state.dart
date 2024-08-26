part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final LoginResponse? loginResponse;
  final bool? registerResponse;

  const AuthState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage = '',
    this.loginResponse,
    this.registerResponse,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    LoginResponse? loginResponse,
    bool? registerResponse
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      loginResponse: loginResponse ?? this.loginResponse,
      registerResponse: registerResponse ?? this.registerResponse,
    );
  }

  @override
  List<Object?> get props => [isLoading, hasError, errorMessage, loginResponse, registerResponse];
}