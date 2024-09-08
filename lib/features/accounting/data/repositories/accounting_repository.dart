import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/datasources/accounting_remote_data_source.dart';
import 'package:akib_pos/features/accounting/data/datasources/local/employee_shared_pref.dart';
import 'package:akib_pos/features/accounting/data/models/accounting_transaction_reporrt_model.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/pending_asset_model.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/sold_asset_model.dart';
import 'package:akib_pos/features/accounting/data/models/cash_flow_report/cash_flow_report_model.dart';
import 'package:akib_pos/features/accounting/data/models/expenditure_report/purchased_product_model.dart';
import 'package:akib_pos/features/accounting/data/models/expenditure_report/total_expenditure.dart';
import 'package:akib_pos/features/accounting/data/models/financial_balance_report/financial_balance_model.dart';
import 'package:akib_pos/features/accounting/data/models/purchasing_report/purchasing_item_model.dart';
import 'package:akib_pos/features/accounting/data/models/sales_report/sales_report_model.dart';
import 'package:akib_pos/features/accounting/data/models/sales_report/sold_product_model.dart';
import 'package:akib_pos/features/accounting/data/models/tax_management_and_tax_services/service_charge_model.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/employee.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/transaction_report_model.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/transcation_summary_response.dart';
import 'package:akib_pos/features/accounting/data/models/purchasing_report/total_purchase_model.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/active_asset_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

abstract class AccountingRepository {
  Future<Either<Failure, TransactionSummaryResponse>>
      getTodayTransactionSummary(int branchId, int companyId);
  Future<Either<Failure, EmployeeListResponse>> getAllEmployees(
      int branchId, int companyId);
  Future<Either<Failure, TransactionReportModel>> getTodayTransactionReport({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  });

  Future<Either<Failure, AccountingTransactionListResponse>>
      getTopTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  });

  Future<Either<Failure, AccountingTransactionListResponse>>
      getDiscountTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  });

  Future<Either<Failure, SalesReportModel>> getSalesReportSummary({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<Either<Failure, List<SoldProductModel>>> getSoldProducts({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<Either<Failure, TotalPurchaseModel>> getTotalPurchase({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<Either<Failure, List<PurchaseItemModel>>> getTotalPurchaseList({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<Either<Failure, TotalExpenditureModel>> getTotalExpenditure({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<Either<Failure, List<PurchasedProductModel>>> getPurchasedProducts({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<Either<Failure, CashFlowReportModel>> getCashFlowReport(
      int branchId, int companyId, String date);

  Future<Either<Failure, List<PendingAssetModel>>> getPendingAssets({
    required int branchId,
    required int companyId,
  });

  Future<Either<Failure, List<ActiveAssetModel>>> getActiveAssets({
    required int branchId,
    required int companyId,
  });

  Future<Either<Failure, List<SoldAssetModel>>> getSoldAssets({
    required int branchId,
    required int companyId,
  });

  Future<Either<Failure, FinancialBalanceModel>> getFinancialBalance({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<Either<Failure, ServiceChargeModel>> getServiceCharge({
    required int branchId,
    required int companyId,
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
  Future<Either<Failure, ServiceChargeModel>> getServiceCharge({
    required int branchId,
    required int companyId,
  }) async {
    try {
      final serviceCharge = await remoteDataSource.getServiceCharge(
        branchId: branchId,
        companyId: companyId,
      );
      return Right(serviceCharge);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FinancialBalanceModel>> getFinancialBalance({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    try {
      final financialBalance = await remoteDataSource.getFinancialBalance(
        branchId: branchId,
        companyId: companyId,
        date: date,
      );
      return Right(financialBalance);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SoldAssetModel>>> getSoldAssets({
    required int branchId,
    required int companyId,
  }) async {
    try {
      final soldAssets = await remoteDataSource.getSoldAssets(
        branchId: branchId,
        companyId: companyId,
      );
      return Right(soldAssets);
    } on ServerException {
      return Left(ServerFailure()); // Custom failure handler
    } catch (e) {
      return Left(GeneralFailure(e.toString())); // Catch any unexpected error
    }
  }

  @override
  Future<Either<Failure, List<ActiveAssetModel>>> getActiveAssets({
    required int branchId,
    required int companyId,
  }) async {
    try {
      final activeAssets = await remoteDataSource.getActiveAssets(
        branchId: branchId,
        companyId: companyId,
      );
      return Right(activeAssets);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PendingAssetModel>>> getPendingAssets({
    required int branchId,
    required int companyId,
  }) async {
    try {
      final pendingAssets = await remoteDataSource.getPendingAssets(
        branchId: branchId,
        companyId: companyId,
      );
      return Right(pendingAssets);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CashFlowReportModel>> getCashFlowReport(
      int branchId, int companyId, String date) async {
    try {
      final cashFlowReport =
          await remoteDataSource.getCashFlowReport(branchId, companyId, date);
      return Right(cashFlowReport);
    } on ServerException {
      return Left(ServerFailure()); // Custom failure handler
    } catch (e) {
      return Left(GeneralFailure(e.toString())); // Catch any unexpected error
    }
  }

  @override
  Future<Either<Failure, List<PurchasedProductModel>>> getPurchasedProducts({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    try {
      final response = await remoteDataSource.getPurchasedProducts(
        branchId: branchId,
        companyId: companyId,
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
  Future<Either<Failure, TotalExpenditureModel>> getTotalExpenditure({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    try {
      final response = await remoteDataSource.getTotalExpenditure(
        branchId: branchId,
        companyId: companyId,
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
  Future<Either<Failure, List<PurchaseItemModel>>> getTotalPurchaseList({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    try {
      final response = await remoteDataSource.getTotalPurchaseList(
        branchId: branchId,
        companyId: companyId,
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
  Future<Either<Failure, TotalPurchaseModel>> getTotalPurchase({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    try {
      final response = await remoteDataSource.getTotalPurchase(
        branchId: branchId,
        companyId: companyId,
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
  Future<Either<Failure, List<SoldProductModel>>> getSoldProducts({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    try {
      final response = await remoteDataSource.getSoldProducts(
        branchId: branchId,
        companyId: companyId,
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
  Future<Either<Failure, SalesReportModel>> getSalesReportSummary({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    try {
      final response = await remoteDataSource.getSalesReportSummary(
        branchId: branchId,
        companyId: companyId,
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
  Future<Either<Failure, AccountingTransactionListResponse>>
      getTopTransactions({
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
  Future<Either<Failure, AccountingTransactionListResponse>>
      getDiscountTransactions({
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
  Future<Either<Failure, EmployeeListResponse>> getAllEmployees(
      int branchId, int companyId) async {
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
        final response =
            await remoteDataSource.getAllEmployees(branchId, companyId);

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
  Future<Either<Failure, TransactionSummaryResponse>>
      getTodayTransactionSummary(int branchId, int companyId) async {
    try {
      final response = await remoteDataSource.getTodayTransactionSummary(
          branchId, companyId);
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
