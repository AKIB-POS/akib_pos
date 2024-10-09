import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/datasources/stockist_remote_data_source.dart';
import 'package:akib_pos/features/stockist/data/models/add_raw_material.dart';
import 'package:akib_pos/features/stockist/data/models/add_raw_material_stock.dart';
import 'package:akib_pos/features/stockist/data/models/add_vendor.dart';
import 'package:akib_pos/features/stockist/data/models/expired_stock.dart';
import 'package:akib_pos/features/stockist/data/models/material_detail.dart';
import 'package:akib_pos/features/stockist/data/models/order_status.dart';
import 'package:akib_pos/features/stockist/data/models/purchase.dart';
import 'package:akib_pos/features/stockist/data/models/purchase_history.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material.dart';
import 'package:akib_pos/features/stockist/data/models/running_out_stock.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_recent_purchase.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_summary.dart';
import 'package:akib_pos/features/stockist/data/models/unit.dart';
import 'package:akib_pos/features/stockist/data/models/vendor.dart';
import 'package:akib_pos/features/stockist/data/models/warehouse.dart';
import 'package:dartz/dartz.dart';

abstract class StockistRepository {
  Future<Either<Failure, StockistSummaryResponse>> getStockistSummary(int branchId);
  Future<Either<Failure, StockistRecentPurchasesResponse>> getStockistRecentPurchases(int branchId);
  Future<Either<Failure, ExpiredStockResponse>> getExpiredStock(int branchId);
  Future<Either<Failure, RunningOutStockResponse>> getRunningOutStock(int branchId);
  Future<Either<Failure, VendorListResponse>> getVendors(int branchId);
  Future<Either<Failure, AddVendorResponse>> addVendor(AddVendorRequest request);
  Future<Either<Failure, RawMaterialListResponse>> getRawMaterials(int branchId);
  Future<Either<Failure, AddRawMaterialResponse>> addRawMaterial(AddRawMaterialRequest request);
  Future<Either<Failure, PurchasesListResponse>> getPurchases(int branchId);
  Future<Either<Failure, MaterialDetailResponse>> getMaterialDetail(int branchId, int materialId);
  Future<Either<Failure, PurchaseHistoryResponse>> getPurchaseHistory(int branchId, int materialId);

  Future<Either<Failure, GetUnitsResponse>> getUnits(int branchId);
  Future<Either<Failure, GetWarehousesResponse>> getWarehouses(int branchId);
  Future<Either<Failure, OrderStatusResponse>> getOrderStatuses(int branchId);

  Future<Either<Failure, AddRawMaterialStockResponse>> addRawMaterialStock(AddRawMaterialStockRequest request);
  
}

class StockistRepositoryImpl implements StockistRepository {
  final StockistRemoteDataSource remoteDataSource;

  StockistRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Either<Failure, AddRawMaterialStockResponse>> addRawMaterialStock(AddRawMaterialStockRequest request) async {
    try {
      final addStockResponse = await remoteDataSource.addRawMaterialStock(request);
      return Right(addStockResponse);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }



  @override
  Future<Either<Failure, OrderStatusResponse>> getOrderStatuses(int branchId) async {
    try {
      final response = await remoteDataSource.getOrderStatuses(branchId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, GetWarehousesResponse>> getWarehouses(int branchId) async {
    try {
      final warehousesResponse = await remoteDataSource.getWarehouses(branchId);
      return Right(warehousesResponse);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetUnitsResponse>> getUnits(int branchId) async {
    try {
      final unitsResponse = await remoteDataSource.getUnits(branchId);
      return Right(unitsResponse);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseHistoryResponse>> getPurchaseHistory(int branchId, int materialId) async {
    try {
      final purchaseHistory = await remoteDataSource.getPurchaseHistory(branchId, materialId);
      return Right(purchaseHistory);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaterialDetailResponse>> getMaterialDetail(int branchId, int materialId) async {
    try {
      final materialDetail = await remoteDataSource.getMaterialDetail(branchId, materialId);
      return Right(materialDetail);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }



  @override
  Future<Either<Failure, PurchasesListResponse>> getPurchases(int branchId) async {
    try {
      final response = await remoteDataSource.getPurchases(branchId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, AddRawMaterialResponse>> addRawMaterial(AddRawMaterialRequest request) async {
    try {
      final response = await remoteDataSource.addRawMaterial(request);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RawMaterialListResponse>> getRawMaterials(int branchId) async {
    try {
      final rawMaterials = await remoteDataSource.getRawMaterials(branchId);
      return Right(rawMaterials);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

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
