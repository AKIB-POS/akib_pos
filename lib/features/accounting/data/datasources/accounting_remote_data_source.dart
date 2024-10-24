import 'dart:convert';
import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/accounting/data/models/accounting_transaction_reporrt_model.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/pending_asset_model.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/sold_asset_model.dart';
import 'package:akib_pos/features/accounting/data/models/cash_flow_report/cash_flow_report_model.dart';
import 'package:akib_pos/features/accounting/data/models/expenditure_report/purchased_product_model.dart';
import 'package:akib_pos/features/accounting/data/models/expenditure_report/total_expenditure.dart';
import 'package:akib_pos/features/accounting/data/models/financial_balance_report/financial_balance_model.dart';
import 'package:akib_pos/features/accounting/data/models/profit_loss/profit_loss_model.dart';
import 'package:akib_pos/features/accounting/data/models/purchasing_report/purchasing_item_model.dart';
import 'package:akib_pos/features/accounting/data/models/sales_report/sales_report_model.dart';
import 'package:akib_pos/features/accounting/data/models/sales_report/sold_product_model.dart';
import 'package:akib_pos/features/accounting/data/models/tax_management_and_tax_services/service_charge_model.dart';
import 'package:akib_pos/features/accounting/data/models/tax_management_and_tax_services/tax_charge_model.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/employee.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/transaction_report_model.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/transcation_summary_response.dart';
import 'package:akib_pos/features/accounting/data/models/purchasing_report/total_purchase_model.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/active_asset_model.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/asset_depreciation_model.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

abstract class AccountingRemoteDataSource {

  
  Future<TransactionSummaryResponse> getTodayTransactionSummary(
      int branchId, int companyId);
  Future<EmployeeListResponse> getAllEmployees(int branchId, int companyId);
  Future<TransactionReportModel> getTodayTransactionReport({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  });

  Future<AccountingTransactionListResponse> getTopTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  });

  Future<AccountingTransactionListResponse> getDiscountTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  });

  Future<SalesReportModel> getSalesReportSummary({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<List<SoldProductModel>> getSoldProducts({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<TotalPurchaseModel> getTotalPurchase({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<List<PurchaseItemModel>> getTotalPurchaseList({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<TotalExpenditureModel> getTotalExpenditure({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<List<PurchasedProductModel>> getPurchasedProducts({
    required int branchId,
    required int companyId,
    required String date,
  });

  Future<CashFlowReportModel> getCashFlowReport(
      int branchId, int companyId, String date);

  Future<List<PendingAssetModel>> getPendingAssets({
    required int branchId,
    required int companyId,
  });

  Future<List<ActiveAssetModel>> getActiveAssets({
    required int branchId,
    required int companyId,
  });

  Future<List<SoldAssetModel>> getSoldAssets({
    required int branchId,
    required int companyId,
  });

  Future<FinancialBalanceModel> getFinancialBalance({
    required int branchId,
    required int companyId,
    required String date,
  });

   Future<ServiceChargeModel> getServiceCharge({
    required int branchId,
    required int companyId,
  });

  Future<void> setServiceCharge({
    required int branchId,
    required int companyId,
    required double amount,
  });


  Future<TaxChargeModel> getTaxCharge({
    required int branchId,
    required int companyId,
  });

  Future<void> setTaxCharge({
    required int branchId,
    required int companyId,
    required double amount,
  });

    Future<List<AssetsDepreciationModel>> getAssetsDepreciation({
    required int branchId,
    required int companyId,
  });


  Future<ProfitLossModel> getProfitLoss({
    required int branchId,
    required int companyId,
    required String date,
  });

}

class AccountingRemoteDataSourceImpl implements AccountingRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  AccountingRemoteDataSourceImpl({
    required this.client,
  });


  @override
  Future<ProfitLossModel> getProfitLoss({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/profit-loss';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'date': date,
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ProfitLossModel.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<AssetsDepreciationModel>> getAssetsDepreciation({
    required int branchId,
    required int companyId,
  }) async {
    const url = '${URLs.baseUrlProd}/assets-depreciation';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString()
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)['data'] as List;
      return jsonResponse.map((e) => AssetsDepreciationModel.fromJson(e)).toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TaxChargeModel> getTaxCharge({
    required int branchId,
    required int companyId,
  }) async {
    const url = '${URLs.baseUrlProd}/tax';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString()
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return TaxChargeModel.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> setTaxCharge({
    required int branchId,
    required int companyId,
    required double amount,
  }) async {
    const url = '${URLs.baseUrlProd}/tax';
    final response = await client.post(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: jsonEncode({
        'branch_id': branchId.toString(),
        'amount': amount.toDouble(),
      }),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // if (jsonResponse['message'] != 'Berhasil Mengatur Pajak') {
      //   throw GeneralException('Error mengatur pajak');
      // }
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

   @override
  Future<void> setServiceCharge({
    required int branchId,
    required int companyId,
    required double amount,
  }) async {
    const url = '${URLs.baseUrlProd}/service-fee';
    final response = await client.post(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: jsonEncode({
        'branch_id': branchId.toString(),
        'amount': amount.toDouble(),
      }),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // if (jsonResponse['message'] != 'Berhasil Mengatur Biaya Layanan') {
      //   throw GeneralException('Error mengatur biaya layanan');
      // }
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }
  


  @override
  Future<ServiceChargeModel> getServiceCharge({
    required int branchId,
    required int companyId,
  }) async {
    const url = '${URLs.baseUrlProd}/service-fee';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString()
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ServiceChargeModel.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<FinancialBalanceModel> getFinancialBalance({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/financial-balance';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

            'date': date,
          }),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return FinancialBalanceModel.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SoldAssetModel>> getSoldAssets({
    required int branchId,
    required int companyId,
  }) async {
    const url = '${URLs.baseUrlProd}/sold-assets';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

          }),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)['data'] as List;
      return jsonResponse
          .map((asset) => SoldAssetModel.fromJson(asset))
          .toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ActiveAssetModel>> getActiveAssets({
    required int branchId,
    required int companyId,
  }) async {
    const url = '${URLs.baseUrlProd}/active-assets';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

          }),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse['data'] as List)
          .map((e) => ActiveAssetModel.fromJson(e))
          .toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PendingAssetModel>> getPendingAssets({
    required int branchId,
    required int companyId,
  }) async {
    const url = '${URLs.baseUrlProd}/pending-assets';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

          }),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse['data'] as List)
          .map((item) => PendingAssetModel.fromJson(item))
          .toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CashFlowReportModel> getCashFlowReport(
      int branchId, int companyId, String date) async {
    const url = '${URLs.baseUrlProd}/cash-flow-report';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),
            'date': date,
          }),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return CashFlowReportModel.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PurchasedProductModel>> getPurchasedProducts({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/list-expenditure';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),
            'date': date,
          }),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => PurchasedProductModel.fromJson(item)).toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TotalExpenditureModel> getTotalExpenditure({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/total-expenditure';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

            'date': date,
          }),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return TotalExpenditureModel.fromJson(json.decode(response.body)['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PurchaseItemModel>> getTotalPurchaseList({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/total-purchase-list';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

            'date': date,
          }),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      var data = (json.decode(response.body)['data'] as List)
          .map((purchase) => PurchaseItemModel.fromJson(purchase))
          .toList();
      return data;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TotalPurchaseModel> getTotalPurchase({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/total-purchase';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

            'date': date,
          }),
          headers: _buildHeaders(),
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return TotalPurchaseModel.fromJson(json.decode(response.body)['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SoldProductModel>> getSoldProducts({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/sold-products';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

            'date': date,
          }),
          headers: _buildHeaders(),
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      var data = (json.decode(response.body)['data'] as List)
          .map((product) => SoldProductModel.fromJson(product))
          .toList();
      return data;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SalesReportModel> getSalesReportSummary({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/sales-report-summary';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

            'date': date,
          }),
          headers: _buildHeaders(),
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return SalesReportModel.fromJson(json.decode(response.body)['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AccountingTransactionListResponse> getTopTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/today-top-transaction-report';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

            'employee_id': employeeId.toString(),
            'date': date,
          }),
          headers: _buildHeaders(),
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return AccountingTransactionListResponse.fromJson(
          json.decode(response.body));
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AccountingTransactionListResponse> getDiscountTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/today-discount-transaction-report';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

            'employee_id': employeeId.toString(),
            'date': date,
          }),
          headers: _buildHeaders(),
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return AccountingTransactionListResponse.fromJson(
          json.decode(response.body));
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TransactionReportModel> getTodayTransactionReport({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlProd}/today-transaction-report';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

            'employee_id': employeeId.toString(),
            'date': date.toString(),
          }),
          headers: _buildHeaders(),
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return TransactionReportModel.fromJson(
          json.decode(response.body)['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<EmployeeListResponse> getAllEmployees(
      int branchId, int companyId) async {
    const url = '${URLs.baseUrlProd}/acounting-all-employee';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            'branch_id': branchId.toString(),

          }),
          headers: _buildHeaders(),
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return EmployeeListResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TransactionSummaryResponse> getTodayTransactionSummary(
      int branchId, int companyId) async {
    final url =
        Uri.parse('${URLs.baseUrlProd}/today-transaction-summary').replace(
      queryParameters: {
        'branch_id': branchId.toString()
      },
    );

    try {
      final response = await http
          .get(
            url,
            headers: _buildHeaders(),
          )
          .timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        return TransactionSummaryResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw GeneralException(jsonDecode(response.body)['message']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is GeneralException || e is ServerException) {
        throw e;
      } else {
        throw GeneralException("Unexpected error occurred");
      }
    }
  }

  Map<String, String> _buildHeaders() {
    final token = sharedPrefsHelper.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
