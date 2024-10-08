import 'dart:convert';

import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/add_vendor.dart';
import 'package:akib_pos/features/stockist/data/models/expired_stock.dart';
import 'package:akib_pos/features/stockist/data/models/running_out_stock.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_recent_purchase.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_summary.dart';
import 'package:akib_pos/features/stockist/data/models/vendor.dart';
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
}

class StockistRemoteDataSourceImpl implements StockistRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  StockistRemoteDataSourceImpl({required this.client});

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

    if (response.statusCode == 200) {
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
