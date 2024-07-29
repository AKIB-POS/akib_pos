import 'package:akib_pos/features/auth/data/models/auth_response.dart';
import 'package:akib_pos/features/auth/data/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
      emit(state.copyWith(isLoading: false, authResponse: response));
    } catch (e) {
      emit(state.copyWith(isLoading: false, hasError: true, errorMessage: e.toString()));
    }
  }
}