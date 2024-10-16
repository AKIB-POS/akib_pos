import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/dashboard/data/datasources/dahboard_remote_data_source.dart';
import 'package:akib_pos/features/dashboard/data/models/branch.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardRepository {
  Future<Either<Failure, BranchesResponse>> getBranches();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final AuthSharedPref authSharedPref;
  final Connectivity connectivity;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.authSharedPref,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, BranchesResponse>> getBranches() async {
    try {
      // Check connectivity
      final connectivityResult = await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        // If offline, get branches from SharedPreferences
        final cachedBranches = authSharedPref.getBranchList();
        if (cachedBranches.isNotEmpty) {
          return Right(BranchesResponse(branches: cachedBranches));
        } else {
          return Left(CacheFailure('No cached data available'));
        }
      } else {
        // If online, fetch branches from API
        final response = await remoteDataSource.getBranches();

        // Clear existing data in shared preferences
        await authSharedPref.clearBranchList();

        // Save new branch list to shared preferences
        await authSharedPref.saveBranchList(response.branches);

        return Right(response);
      }
    } catch (e) {
      return Left(GeneralFailure("Unexpected error occurred"));
    }
  }
}
