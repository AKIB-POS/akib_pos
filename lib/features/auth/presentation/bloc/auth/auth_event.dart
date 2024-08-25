part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String username;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String companyName;
  final String companyEmail;
  final String companyPhone;
  final String companyAddress;


  const RegisterRequested(this.email, this.password, this.username, this.phone, this.passwordConfirmation, this.companyName, this.companyEmail, this.companyPhone, this.companyAddress);

  @override
  List<Object> get props => [username, phone, email, password, passwordConfirmation, companyName, companyPhone, companyEmail, companyAddress];
}