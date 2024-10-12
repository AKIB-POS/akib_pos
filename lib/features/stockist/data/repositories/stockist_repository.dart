import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/datasources/stockist_remote_data_source.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/add_equipment_type.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/equipment_detail.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/equipment_purchase.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material/add_raw_material.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material/add_raw_material_stock.dart';
import 'package:akib_pos/features/stockist/data/models/add_vendor.dart';
import 'package:akib_pos/features/stockist/data/models/expired_stock.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material/material_detail.dart';
import 'package:akib_pos/features/stockist/data/models/order_status.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material/raw_material_purchase.dart';
import 'package:akib_pos/features/stockist/data/models/purchase_history.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/equipment.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material/raw_material.dart';
import 'package:akib_pos/features/stockist/data/models/stock/running_out_stock.dart';
import 'package:akib_pos/features/stockist/data/models/stock/stockist_recent_purchase.dart';
import 'package:akib_pos/features/stockist/data/models/stock/stockist_summary.dart';
import 'package:akib_pos/features/stockist/data/models/unit.dart';
import 'package:akib_pos/features/stockist/data/models/vendor.dart';
import 'package:akib_pos/features/stockist/data/models/warehouse.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/add_equipment_stock.dart';
import 'package:akib_pos/features/stockist/presentation/pages/equipment/equipment_purchase_history.dart';
import 'package:dartz/dartz.dart';

abstract class StockistRepository {
  Future<Either<Failure, StockistSummaryResponse>> getStockistSummary(int branchId);
  Future<Either<Failure, StockistRecentPurchasesResponse>> getStockistRecentPurchases(int branchId);
  Future<Either<Failure, ExpiredStockResponse>> getExpiredStock(int branchId);
  Future<Either<Failure, RunningOutStockResponse>> getRunningOutStock(int branchId);
  Future<Either<Failure, VendorListResponse>> getVendors(int branchId);
  Future<Either<Failure, AddVendorResponse>> addVendor(AddVendorRequest request);
  Future<Either<Failure, RawMaterialTypeResponse>> getRawMaterialTypes(int branchId);
  Future<Either<Failure, AddRawMaterialResponse>> addRawMaterial(AddRawMaterialRequest request);
  Future<Either<Failure, RawMaterialPurchasesResponse>> getRawMaterialPurcases(int branchId);
  Future<Either<Failure, MaterialDetailResponse>> getMaterialDetail(int branchId, int materialId);
  Future<Either<Failure, RawMaterialPurchaseHistoryResponse>> getRawMaterialPurchaseHistory(int branchId, int materialId);

  Future<Either<Failure, GetUnitsResponse>> getUnits(int branchId);
  Future<Either<Failure, GetWarehousesResponse>> getWarehouses(int branchId);
  Future<Either<Failure, OrderStatusResponse>> getOrderStatuses(int branchId);

  Future<Either<Failure, AddRawMaterialStockResponse>> addRawMaterialStock(AddRawMaterialStockRequest request);
  Future<Either<Failure, EquipmentTypeResponse>> getEquipmentType(int branchId, String category);
  Future<Either<Failure, AddEquipmentTypeResponse>> addEquipmentType(AddEquipmentTypeRequest request);

  Future<Either<Failure, EquipmentPurchaseResponse>> getEquipmentPurchases(int branchId);
  Future<Either<Failure, EquipmentDetailResponse>> getEquipmentDetail(int branchId, int equipmentId);
  Future<Either<Failure, EquipmentPurchaseHistoryResponse>> getEquipmentPurchaseHistory(int branchId, int equipmentId);
  Future<Either<Failure, AddEquipmentStockResponse>> addEquipmentStock(AddEquipmentStockRequest request);

  
}

class StockistRepositoryImpl implements StockistRepository {
  final StockistRemoteDataSource remoteDataSource;

  StockistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AddEquipmentStockResponse>> addEquipmentStock(AddEquipmentStockRequest request) async {
    try {
      final response = await remoteDataSource.addEquipmentStock(request);
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EquipmentPurchaseHistoryResponse>> getEquipmentPurchaseHistory(int branchId, int equipmentId) async {
    try {
      final purchaseHistory = await remoteDataSource.getEquipmentPurchaseHistory(branchId, equipmentId);
      return Right(purchaseHistory);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, EquipmentDetailResponse>> getEquipmentDetail(int branchId, int equipmentId) async {
    try {
      final equipmentDetail = await remoteDataSource.getEquipmentDetail(branchId, equipmentId);
      return Right(equipmentDetail);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EquipmentPurchaseResponse>> getEquipmentPurchases(int branchId) async {
    try {
      final equipmentPurchases = await remoteDataSource.getEquipmentPurchases(branchId);
      return Right(equipmentPurchases);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

   @override
  Future<Either<Failure, AddEquipmentTypeResponse>> addEquipmentType(AddEquipmentTypeRequest request) async {
    try {
      final result = await remoteDataSource.addEquipmentType(request);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  
  @override
  Future<Either<Failure, EquipmentTypeResponse>> getEquipmentType(int branchId, String category) async {
    try {
      final response = await remoteDataSource.getEquipmentType(branchId, category);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

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
  Future<Either<Failure, RawMaterialPurchaseHistoryResponse>> getRawMaterialPurchaseHistory(int branchId, int materialId) async {
    try {
      final RawMaterialpurchaseHistory = await remoteDataSource.getRawMaterialPurchaseHistory(branchId, materialId);
      return Right(RawMaterialpurchaseHistory);
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
  Future<Either<Failure, RawMaterialPurchasesResponse>> getRawMaterialPurcases(int branchId) async {
    try {
      final response = await remoteDataSource.getRawMaterialPurcases(branchId);
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
  Future<Either<Failure, RawMaterialTypeResponse>> getRawMaterialTypes(int branchId) async {
    try {
      final rawMaterialTypes = await remoteDataSource.getRawMaterialTypes(branchId);
      return Right(rawMaterialTypes);
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
