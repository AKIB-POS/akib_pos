import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/datasources/stockist_remote_data_source.dart';
import 'package:akib_pos/features/stockist/data/models/add_vendor.dart';
import 'package:akib_pos/features/stockist/data/models/expired_stock.dart';
import 'package:akib_pos/features/stockist/data/models/running_out_stock.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_recent_purchase.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_summary.dart';
import 'package:akib_pos/features/stockist/data/models/vendor.dart';
import 'package:dartz/dartz.dart';

abstract class StockistRepository {
  Future<Either<Failure, StockistSummaryResponse>> getStockistSummary(int branchId);
  Future<Either<Failure, StockistRecentPurchasesResponse>> getStockistRecentPurchases(int branchId);
  Future<Either<Failure, ExpiredStockResponse>> getExpiredStock(int branchId);
  Future<Either<Failure, RunningOutStockResponse>> getRunningOutStock(int branchId);
  Future<Either<Failure, VendorListResponse>> getVendors(int branchId);
  Future<Either<Failure, AddVendorResponse>> addVendor(AddVendorRequest request);
}

class StockistRepositoryImpl implements StockistRepository {
  final StockistRemoteDataSource remoteDataSource;

  StockistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AddVendorResponse>> addVendor(AddVendorRequest request) async {
    try {
      final response = await remoteDataSource.addVendor(request);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, VendorListResponse>> getVendors(int branchId) async {
    try {
      final vendors = await remoteDataSource.getVendors(branchId);
      return Right(vendors);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, RunningOutStockResponse>> getRunningOutStock(int branchId) async {
    try {
      final runningOutStock = await remoteDataSource.getRunningOutStock(branchId);
      return Right(runningOutStock);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }



  @override
  Future<Either<Failure, ExpiredStockResponse>> getExpiredStock(int branchId) async {
    try {
      final expiredStock = await remoteDataSource.getExpiredStock(branchId);
      return Right(expiredStock);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, StockistRecentPurchasesResponse>> getStockistRecentPurchases(int branchId) async {
    try {
      final recentPurchases = await remoteDataSource.getStockistRecentPurchases(branchId);
      return Right(recentPurchases);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StockistSummaryResponse>> getStockistSummary(int branchId) async {
    try {
      final stockistSummary = await remoteDataSource.getStockistSummary(branchId);
      return Right(stockistSummary);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


}
