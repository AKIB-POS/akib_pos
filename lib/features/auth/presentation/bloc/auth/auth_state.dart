part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final AuthResponse? authResponse;

  const AuthState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage = '',
    this.authResponse,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    AuthResponse? authResponse,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      authResponse: authResponse ?? this.authResponse,
    );
  }

  @override
  List<Object?> get props => [isLoading, hasError, errorMessage, authResponse];
}