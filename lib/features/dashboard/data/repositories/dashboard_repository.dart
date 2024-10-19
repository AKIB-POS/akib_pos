import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/dashboard/data/datasources/dahboard_remote_data_source.dart';
import 'package:akib_pos/features/dashboard/data/models/branch.dart';
import 'package:akib_pos/features/dashboard/data/models/dashboard_accounting_summary.dart';
import 'package:akib_pos/features/dashboard/data/models/dashboard_summary_response.dart';
import 'package:akib_pos/features/dashboard/data/models/dashbord_summary_stock.dart';
import 'package:akib_pos/features/dashboard/data/models/purchase_chart.dart';
import 'package:akib_pos/features/dashboard/data/models/sales_chart.dart';
import 'package:akib_pos/features/dashboard/data/models/top_products.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardRepository {
  Future<Either<Failure, BranchesResponse>> getBranches();
  Future<Either<Failure, DashboardAccountingSummaryResponse>> getAccountingSummary(int branchId);
  Future<Either<Failure, TopProductsResponse>> getTopProducts(int branchId);
  Future<Either<Failure, SalesChartResponse>> getSalesChart(int branchId);
  Future<Either<Failure, PurchaseChartResponse>> getPurchaseChart(int branchId);
  Future<Either<Failure, DashboardSummaryHrdResponse>> getDashboardHrdSummary(int branchId);
  Future<Either<Failure, DashboardSummaryStockResponse>> getStockSummary(int branchId);
  
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
  Future<Either<Failure, DashboardSummaryStockResponse>> getStockSummary(int branchId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return Left(NetworkFailure('No Internet connection'));
      } else {
        final response = await remoteDataSource.getStockSummary(branchId);
        return Right(response);
      }
    } catch (e) {
      return Left(GeneralFailure("Unexpected error occurred"));
    }
  }

   @override
  Future<Either<Failure, DashboardSummaryHrdResponse>> getDashboardHrdSummary(int branchId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return Left(NetworkFailure('No Internet connection'));
      }
      final response = await remoteDataSource.getDashboardHrdSummary(branchId);
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure('Failed to fetch HRD summary'));
    }
  }

  @override
  Future<Either<Failure, PurchaseChartResponse>> getPurchaseChart(int branchId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return Left(NetworkFailure('No Internet connection'));
      }
      final response = await remoteDataSource.getPurchaseChart(branchId);
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure('Failed to fetch purchase chart data'));
    }
  }


  @override
  Future<Either<Failure, SalesChartResponse>> getSalesChart(int branchId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return Left(NetworkFailure('No Internet connection'));
      }
      final salesChart = await remoteDataSource.getSalesChart(branchId);
      return Right(salesChart);
    } catch (e) {
      return Left(GeneralFailure('Failed to fetch sales chart data.'));
    }
  }

  @override
  Future<Either<Failure, TopProductsResponse>> getTopProducts(int branchId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return Left(NetworkFailure('No Internet connection'));
      }

      final topProductsResponse = await remoteDataSource.getTopProducts(branchId);
      return Right(topProductsResponse);
    } catch (e) {
      return Left(GeneralFailure("Failed to fetch top products"));
    }
  }

  @override
  Future<Either<Failure, DashboardAccountingSummaryResponse>> getAccountingSummary(int branchId) async {
    try {
      // Check connectivity
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return Left(NetworkFailure('No Internet connection'));
      }
      final response = await remoteDataSource.getAccountingSummary(branchId);
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure('Failed to fetch accounting summary'));
    }
  }

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
