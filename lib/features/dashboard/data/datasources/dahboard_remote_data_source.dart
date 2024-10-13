import 'dart:convert';

import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/dashboard/data/models/branch.dart';
import 'package:akib_pos/features/dashboard/data/models/dashboard_accounting_summary.dart';
import 'package:akib_pos/features/dashboard/data/models/dashboard_summary_response.dart';
import 'package:akib_pos/features/dashboard/data/models/purchase_chart.dart';
import 'package:akib_pos/features/dashboard/data/models/sales_chart.dart';
import 'package:akib_pos/features/dashboard/data/models/top_products.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
abstract class DashboardRemoteDataSource {
  Future<BranchesResponse> getBranches();
  Future<DashboardAccountingSummaryResponse> getAccountingSummary(int branchId);
  Future<TopProductsResponse> getTopProducts(int branchId);
  Future<SalesChartResponse> getSalesChart(int branchId);
  Future<PurchaseChartResponse> getPurchaseChart(int branchId);
  Future<DashboardSummaryHrdResponse> getDashboardHrdSummary(int branchId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  DashboardRemoteDataSourceImpl({required this.client});


  @override
  Future<DashboardSummaryHrdResponse> getDashboardHrdSummary(int branchId) async {
    final url = '${URLs.baseUrlProd}/dashboard-hrd-summary?branch_id=$branchId';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return DashboardSummaryHrdResponse.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<PurchaseChartResponse> getPurchaseChart(int branchId) async {
    const url = '${URLs.baseUrlMock}/purchase-chart';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PurchaseChartResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SalesChartResponse> getSalesChart(int branchId) async {
    const url = '${URLs.baseUrlMock}/sales-chart';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SalesChartResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TopProductsResponse> getTopProducts(int branchId) async {
    final url = '${URLs.baseUrlMock}/dashboard-top-products';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branchId': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return TopProductsResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<DashboardAccountingSummaryResponse> getAccountingSummary(int branchId) async {
    const url = '${URLs.baseUrlMock}/dashboard-accounting-summary';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {'branchId': branchId.toString()}),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)['data'];
      return DashboardAccountingSummaryResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<BranchesResponse> getBranches() async {
    const url = '${URLs.baseUrlProd}/branches';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return BranchesResponse.fromJson(jsonResponse);
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
