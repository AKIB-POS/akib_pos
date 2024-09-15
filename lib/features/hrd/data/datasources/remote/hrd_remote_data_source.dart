import 'dart:convert';

import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_summary.dart';
import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;

abstract class HRDRemoteDataSource {
  Future<AttendanceSummaryResponse> getAttendanceSummary(int branchId, int companyId);
  // Add other HRD-related methods here
}
class HRDRemoteDataSourceImpl implements HRDRemoteDataSource {
  final http.Client client;
   final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  HRDRemoteDataSourceImpl({required this.client});

  @override
  Future<AttendanceSummaryResponse> getAttendanceSummary(int branchId, int companyId) async {
    const url = '${URLs.baseUrlMock}/api/attendance-summary';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'company_id': companyId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AttendanceSummaryResponse.fromJson(jsonResponse);
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
