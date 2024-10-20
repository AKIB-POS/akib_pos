import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/auth/data/datasources/remote_data_source/remote_auth_data_sources.dart';
import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:dartz/dartz.dart';


abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(String email, String password, bool isCashier);
  
  Future<Either<Failure, bool>> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String phone,
    String companyName,
    String? companyEmail,
    String companyPhone,
    String companyAddress,
  });
}


class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource _remoteDataSource;
  final AuthSharedPref _authSharedPref;

  AuthRepositoryImpl(this._remoteDataSource, this._authSharedPref);

  @override
  Future<Either<Failure, LoginResponse>> login(String email, String password, bool isCashier) async {
    try {
      final response = await _remoteDataSource.login(email: email, password: password,isCashier : isCashier);
      await _authSharedPref.saveLoginResponse(response);
      return Right(response);
    } on GeneralException catch (e) {
      return Left(GeneralFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String phone = '',
    String companyName = "-",
    String? companyEmail,
    String companyPhone = "-",
    String companyAddress = "-",
  }) async {
    try {
      final response = await _remoteDataSource.register(
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
      return Right(response);
    } on GeneralException catch (e) {
      return Left(GeneralFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
