import 'dart:convert';

import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/attendance_history_item.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_request_data.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_summary.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/check_in_out_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_quota.dart';
import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;

abstract class HRDRemoteDataSource {
  Future<AttendanceSummaryResponse> getAttendanceSummary(
      int branchId, int companyId);
  Future<CheckInOutResponse> checkIn(CheckInOutRequest request);
  Future<CheckInOutResponse> checkOut(CheckInOutRequest request);
  Future<AttendanceHistoryResponse> getAttendanceHistory();
  Future<LeaveRequestResponse> getLeaveRequests();
  Future<LeaveQuotaResponse> getLeaveQuota();
}

class HRDRemoteDataSourceImpl implements HRDRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  HRDRemoteDataSourceImpl({required this.client});


  @override
  Future<LeaveRequestResponse> getLeaveRequests() async {
    const url = '${URLs.baseUrlMock}/leave-requests';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return LeaveRequestResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<LeaveQuotaResponse> getLeaveQuota() async {
    const url = '${URLs.baseUrlMock}/leave-quota';
    final response = await client
        .get(
          Uri.parse(url),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return LeaveQuotaResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AttendanceHistoryResponse> getAttendanceHistory() async {
    // No parameters required
    const url = '${URLs.baseUrlMock}/attendance-history';
    final response = await client
        .get(
          Uri.parse(url),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AttendanceHistoryResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AttendanceSummaryResponse> getAttendanceSummary(
      int branchId, int companyId) async {
    const url = '${URLs.baseUrlMock}/attendance-summary';
    final response = await client
        .get(
          Uri.parse(url).replace(queryParameters: {
            // 'branch_id': branchId.toString(),
            // 'company_id': companyId.toString(),
          }),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AttendanceSummaryResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CheckInOutResponse> checkIn(CheckInOutRequest request) async {
    const url = '${URLs.baseUrlMock}/check-in';
    final response = await client
        .post(
          Uri.parse(url),
          headers: _buildHeaders(),
          body: json.encode(request.toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return CheckInOutResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CheckInOutResponse> checkOut(CheckInOutRequest request) async {
    const url = '${URLs.baseUrlMock}/check-out';
    final response = await client
        .post(
          Uri.parse(url),
          headers: _buildHeaders(),
          body: json.encode(request.toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return CheckInOutResponse.fromJson(jsonResponse);
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
