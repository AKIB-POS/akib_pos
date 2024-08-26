import 'package:akib_pos/features/auth/data/datasources/remote_auth_data_sources.dart';
import 'package:akib_pos/features/auth/data/models/login_response.dart';


class AuthRepository {
  final RemoteAuthDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<LoginResponse> login(String email, String password) async {
    return await _remoteDataSource.login(email: email, password: password);
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String phone = '',
    String companyName = "-",
    String? companyEmail,
    String companyPhone = "-",
    String companyAddress = "-"
    }) async {
    return await _remoteDataSource.register(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        username: username,
        companyName: companyName,
        companyEmail: companyEmail ?? email,
        companyAddress: companyAddress,
        companyPhone: companyPhone
    );
  }
}