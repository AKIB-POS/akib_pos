import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/datasources/stockist_remote_data_source.dart';
import 'package:akib_pos/features/stockist/data/models/expired_stock.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_recent_purchase.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_summary.dart';
import 'package:dartz/dartz.dart';

abstract class StockistRepository {
  Future<Either<Failure, StockistSummaryResponse>> getStockistSummary(int branchId);
  Future<Either<Failure, StockistRecentPurchasesResponse>> getStockistRecentPurchases(int branchId);
  Future<Either<Failure, ExpiredStockResponse>> getExpiredStock(int branchId);
}

class StockistRepositoryImpl implements StockistRepository {
  final StockistRemoteDataSource remoteDataSource;

  StockistRepositoryImpl({required this.remoteDataSource});


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
