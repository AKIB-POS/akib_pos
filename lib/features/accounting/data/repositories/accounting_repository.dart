import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/datasources/accounting_remote_data_source.dart';
import 'package:akib_pos/features/accounting/data/datasources/local/employee_shared_pref.dart';
import 'package:akib_pos/features/accounting/data/models/accounting_transaction_reporrt_model.dart';
import 'package:akib_pos/features/accounting/data/models/employee.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report_model.dart';
import 'package:akib_pos/features/accounting/data/models/transcation_summary_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

abstract class AccountingRepository {
  Future<Either<Failure, TransactionSummaryResponse>> getTodayTransactionSummary(int branchId, int companyId);
   Future<Either<Failure, EmployeeListResponse>> getAllEmployees(int branchId, int companyId);
   Future<Either<Failure, TransactionReportModel>> getTodayTransactionReport({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  });

  Future<Either<Failure, AccountingTransactionListResponse>> getTopTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  });

  Future<Either<Failure, AccountingTransactionListResponse>> getDiscountTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  });
}

class AccountingRepositoryImpl implements AccountingRepository {
  final AccountingRemoteDataSource remoteDataSource;
  final EmployeeSharedPref employeeSharedPref;
  final Connectivity connectivity;

  

  AccountingRepositoryImpl({
    required this.remoteDataSource,
    required this.employeeSharedPref,
    required this.connectivity,
    });



  @override
  Future<Either<Failure, AccountingTransactionListResponse>> getTopTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  }) async {
    try {
      final response = await remoteDataSource.getTopTransactions(
        branchId: branchId,
        companyId: companyId,
        employeeId: employeeId,
        date: date,
      );
      return Right(response);
    } catch (e) {
      if (e is GeneralException) {
        return Left(GeneralFailure(e.message));
      } else if (e is ServerException) {
        return Left(ServerFailure());
      } else {
        return Left(GeneralFailure("Unexpected error occurred"));
      }
    }
  }

  @override
  Future<Either<Failure, AccountingTransactionListResponse>> getDiscountTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  }) async {
    try {
      final response = await remoteDataSource.getDiscountTransactions(
        branchId: branchId,
        companyId: companyId,
        employeeId: employeeId,
        date: date,
      );
      return Right(response);
    } catch (e) {
      if (e is GeneralException) {
        return Left(GeneralFailure(e.message));
      } else if (e is ServerException) {
        return Left(ServerFailure());
      } else {
        return Left(GeneralFailure("Unexpected error occurred"));
      }
    }
  }

    @override
  Future<Either<Failure, TransactionReportModel>> getTodayTransactionReport({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  }) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        // Handle offline scenario
        return Left(CacheFailure('No internet connection.'));
      } else {
        final response = await remoteDataSource.getTodayTransactionReport(
          branchId: branchId,
          companyId: companyId,
          employeeId: employeeId,
          date: date,
        );
        return Right(response);
      }
    } catch (e) {
      if (e is GeneralException) {
        return Left(GeneralFailure(e.message));
      } else if (e is ServerException) {
        return Left(ServerFailure());
      } else {
        return Left(GeneralFailure("Unexpected error occurred"));
      }
    }
  }

  @override
  Future<Either<Failure, EmployeeListResponse>> getAllEmployees(int branchId, int companyId) async {
    try {
      // Check connectivity status
      final connectivityResult = await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        // If offline, fetch data from SharedPreferences
        final cachedEmployees = employeeSharedPref.getEmployeeList();
        if (cachedEmployees.isNotEmpty) {
          return Right(EmployeeListResponse(
            message: 'Data fetched from cache',
            data: cachedEmployees,
          ));
        } else {
          return Left(CacheFailure('No cached data available'));
        }
      } else {
        // If online, fetch new data from API
        final response = await remoteDataSource.getAllEmployees(branchId, companyId);

        // Clear existing data in shared preferences
        await employeeSharedPref.clearEmployeeList();

        // Save new data to shared preferences
        await employeeSharedPref.saveEmployeeList(response.data);

        return Right(response);
      }
    } catch (e) {
      if (e is GeneralException) {
        return Left(GeneralFailure(e.message));
      } else if (e is ServerException) {
        return Left(ServerFailure());
      } else if (e is CacheFailure) {
        return Left(e);
      } else {
        return Left(GeneralFailure("Unexpected error occurred"));
      }
    }
  }

  @override
  Future<Either<Failure, TransactionSummaryResponse>> getTodayTransactionSummary(int branchId, int companyId) async {
    try {
      final response = await remoteDataSource.getTodayTransactionSummary(branchId, companyId);
      return Right(response);
    } catch (e) {
      if (e is GeneralException) {
        return Left(GeneralFailure(e.message));
      } else if (e is ServerException) {
        return Left(ServerFailure());
      } else {
        return Left(GeneralFailure("Unexpected error occurred"));
      }
    }
  }
}
