import 'dart:convert';

import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/accounting/data/models/transcation_summary_response.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
abstract class AccountingRemoteDataSource {
  Future<TransactionSummaryResponse> getTodayTransactionSummary(int branchId, int companyId);
}

class AccountingRemoteDataSourceImpl implements AccountingRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  AccountingRemoteDataSourceImpl({
    required this.client,
  });


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
