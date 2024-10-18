import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/settings/data/datasources/setting_remote_data_source.dart';
import 'package:akib_pos/features/settings/data/models/change_password_request.dart';
import 'package:akib_pos/features/settings/data/models/personal_information.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

abstract class SettingRepository {
  Future<Either<Failure, PersonalInformationResponse>> getPersonalInformation();
  Future<Either<Failure, ChangePasswordResponse>> changePassword(ChangePasswordRequest request);
  
}

class SettingRepositoryImpl implements SettingRepository {
  final SettingRemoteDataSource remoteDataSource;
  final Connectivity connectivity;

  SettingRepositoryImpl({
    required this.remoteDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, ChangePasswordResponse>> changePassword(ChangePasswordRequest request) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return Left(NetworkFailure('No Internet connection'));
      } else {
        final changePasswordResponse = await remoteDataSource.changePassword(request);
        return Right(changePasswordResponse);
      }
    } catch (e) {
      return Left(GeneralFailure('Failed to change password'));
    }
  }

  @override
  Future<Either<Failure, PersonalInformationResponse>> getPersonalInformation() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return Left(NetworkFailure('No Internet connection'));
      } else {
        final personalInfo = await remoteDataSource.getPersonalInformation();
        return Right(personalInfo);
      }
    } catch (e) {
      return Left(GeneralFailure('Failed to fetch personal information'));
    }
  }
}
