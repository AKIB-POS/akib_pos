import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:akib_pos/features/auth/data/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/register_response.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<LoginRequested>(_onLoginRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await _authRepository.login(event.email, event.password);
      emit(state.copyWith(isLoading: false, loginResponse: response));
    } catch (e) {
      emit(state.copyWith(isLoading: false, hasError: true, errorMessage: e.toString()));
    }
  }

  void _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await _authRepository.register(
          email: event.email,
          password: event.password,
          passwordConfirmation: event.passwordConfirmation,
          phone: event.phone,
          username: event.username,
          companyName: event.companyName,
          companyEmail: event.companyEmail ?? event.email,
          companyAddress: event.companyAddress,
          companyPhone: event.companyPhone

      );
      emit(state.copyWith(isLoading: false, registerResponse: response));
    } catch (e) {
      emit(state.copyWith(isLoading: false, hasError: true, errorMessage: e.toString()));
    }
  }
}