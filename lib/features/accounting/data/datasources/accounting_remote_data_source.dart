import 'dart:convert';

import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/accounting/data/models/accounting_transaction_reporrt_model.dart';
import 'package:akib_pos/features/accounting/data/models/sales_report/sales_report_model.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/employee.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/transaction_report_model.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/transcation_summary_response.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
abstract class AccountingRemoteDataSource {
  Future<TransactionSummaryResponse> getTodayTransactionSummary(int branchId, int companyId);
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
}

class AccountingRemoteDataSourceImpl implements AccountingRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  AccountingRemoteDataSourceImpl({
    required this.client,
  });


  @override
  Future<SalesReportModel> getSalesReportSummary({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    const url = '${URLs.baseUrlMock}/sales-report-summary';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'company_id': companyId.toString(),
        'date': date,
      }),
      headers: _buildHeaders(),
    ).timeout(Duration(seconds: 30));

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
    const url = '${URLs.baseUrlMock}/today-top-transaction-report';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'company_id': companyId.toString(),
        'employee_id': employeeId.toString(),
        'date': date,
      }),
      headers: _buildHeaders(),
    ).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return AccountingTransactionListResponse.fromJson(json.decode(response.body));
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
    const url = '${URLs.baseUrlMock}/today-discount-transaction-report';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'company_id': companyId.toString(),
        'employee_id': employeeId.toString(),
        'date': date,
      }),
      headers: _buildHeaders(),
    ).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return AccountingTransactionListResponse.fromJson(json.decode(response.body));
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
    const url = '${URLs.baseUrlMock}/today-transaction-report';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'company_id': companyId.toString(),
        'employee_id': employeeId.toString(),
        'date': date.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return TransactionReportModel.fromJson(json.decode(response.body)['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<EmployeeListResponse> getAllEmployees(int branchId, int companyId) async {
    const url = '${URLs.baseUrlMock}/all-employee';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'company_id': companyId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return EmployeeListResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<TransactionSummaryResponse> getTodayTransactionSummary(int branchId, int companyId) async {
  final url = Uri.parse('${URLs.baseUrlMock}/today-transaction-summary').replace(
    queryParameters: {
      'branch_id': branchId.toString(),
      'company_id': companyId.toString(),
    },
  );

  try {
    final response = await http.get(
      url,
      headers: _buildHeaders(),
    ).timeout(Duration(seconds: 30));

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
