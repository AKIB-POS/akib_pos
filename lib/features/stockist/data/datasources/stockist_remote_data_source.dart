import 'dart:convert';

import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
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
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

abstract class StockistRemoteDataSource {
  Future<StockistSummaryResponse> getStockistSummary(int branchId);
  Future<StockistRecentPurchasesResponse> getStockistRecentPurchases(int branchId);
  Future<ExpiredStockResponse> getExpiredStock(int branchId);
  Future<RunningOutStockResponse> getRunningOutStock(int branchId);
  Future<VendorListResponse> getVendors(int branchId);
  Future<AddVendorResponse> addVendor(AddVendorRequest request);
  Future<RawMaterialListResponse> getRawMaterials(int branchId);
  Future<AddRawMaterialResponse> addRawMaterial(AddRawMaterialRequest request);
  Future<PurchasesListResponse> getPurchases(int branchId);
  Future<MaterialDetailResponse> getMaterialDetail(int branchId, int materialId);
  Future<PurchaseHistoryResponse> getPurchaseHistory(int branchId, int materialId);

  Future<GetUnitsResponse> getUnits(int branchId);
  Future<GetWarehousesResponse> getWarehouses(int branchId);
  Future<OrderStatusResponse> getOrderStatuses(int branchId);
  Future<AddRawMaterialStockResponse> addRawMaterialStock(AddRawMaterialStockRequest request);
}

class StockistRemoteDataSourceImpl implements StockistRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  StockistRemoteDataSourceImpl({required this.client});


  @override
  Future<AddRawMaterialStockResponse> addRawMaterialStock(AddRawMaterialStockRequest request) async {
    const url = '${URLs.baseUrlMock}/add-raw-material-stock';
    final response = await client.post(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: json.encode(request.toJson()),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AddRawMaterialStockResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


   @override
  Future<OrderStatusResponse> getOrderStatuses(int branchId) async {
    final url = '${URLs.baseUrlMock}/order-status?branch_id=$branchId';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return OrderStatusResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<GetWarehousesResponse> getWarehouses(int branchId) async {
    const url = '${URLs.baseUrlMock}/warehouses';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return GetWarehousesResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<GetUnitsResponse> getUnits(int branchId) async {
    const url = '${URLs.baseUrlMock}/units';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return GetUnitsResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


@override
  Future<PurchaseHistoryResponse> getPurchaseHistory(int branchId, int materialId) async {
    const url = '${URLs.baseUrlMock}/purchase-history';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branchId': branchId.toString(),
        'material_id': materialId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PurchaseHistoryResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  
@override
  Future<MaterialDetailResponse> getMaterialDetail(int branchId, int materialId) async {
    final url = '${URLs.baseUrlMock}/material-detail';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branchId': branchId.toString(),
        'material_id': materialId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return MaterialDetailResponse.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }
  
  @override
  Future<PurchasesListResponse> getPurchases(int branchId) async {
    const url = '${URLs.baseUrlMock}/purchases';
    
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branchId': branchId.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sharedPrefsHelper.getToken()}',
      },
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PurchasesListResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AddRawMaterialResponse> addRawMaterial(AddRawMaterialRequest request) async {
    const url = '${URLs.baseUrlMock}/raw-materials';
    
    final response = await client.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sharedPrefsHelper.getToken()}',
      },
      body: json.encode(request.toJson()),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return AddRawMaterialResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<RawMaterialListResponse> getRawMaterials(int branchId) async {
    const url = '${URLs.baseUrlMock}/raw-materials';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return RawMaterialListResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AddVendorResponse> addVendor(AddVendorRequest request) async {
    const url = '${URLs.baseUrlMock}/vendors';
    final response = await client.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sharedPrefsHelper.getToken()}',
      },
      body: json.encode(request.toJson()),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return AddVendorResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  

  @override
  Future<VendorListResponse> getVendors(int branchId) async {
    const url = '${URLs.baseUrlMock}/vendors';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return VendorListResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<RunningOutStockResponse> getRunningOutStock(int branchId) async {
    const url = '${URLs.baseUrlMock}/stock-running-out';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return RunningOutStockResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


   @override
  Future<ExpiredStockResponse> getExpiredStock(int branchId) async {
    const url = '${URLs.baseUrlMock}/expired-stock';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ExpiredStockResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<StockistRecentPurchasesResponse> getStockistRecentPurchases(int branchId) async {
    const url = '${URLs.baseUrlMock}/stockist-recent-purchases';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return StockistRecentPurchasesResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<StockistSummaryResponse> getStockistSummary(int branchId) async {
    const url = '${URLs.baseUrlMock}/stockist-summary';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return StockistSummaryResponse.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefsHelper.getToken()}',
    };
  }
}