import 'package:akib_pos/features/auth/data/datasources/remote_auth_data_sources.dart';
import 'package:akib_pos/features/auth/data/models/auth_response.dart';


class AuthRepository {
  final RemoteAuthDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<AuthResponse> login(String email, String password) async {
    return await _remoteDataSource.login(email, password);
  }
}