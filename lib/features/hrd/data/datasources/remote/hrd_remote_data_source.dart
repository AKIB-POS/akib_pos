import 'dart:convert';

import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/attendance_history_item.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_history.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_request_data.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_history.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_history.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_quota.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/check_in_out_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_quota.dart';
import 'package:akib_pos/features/hrd/data/models/attenddance_recap.dart';
import 'package:akib_pos/features/hrd/data/models/candidate_submission.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/salary/salary_slip.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/salary/salary_slip_detail.dart';
import 'package:akib_pos/features/hrd/data/models/hrd_summary.dart';
import 'package:akib_pos/features/hrd/data/models/submission.dart';
import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;

abstract class HRDRemoteDataSource {
  Future<HRDSummaryResponse> getHRDSummary(int branchId);

  //HRDPage

  //Attendance
  Future<CheckInOutResponse> checkIn(CheckInOutRequest request);
  Future<CheckInOutResponse> checkOut(CheckInOutRequest request);
  Future<AttendanceHistoryResponse> getAttendanceHistory();
   Future<AttendanceRecap> getAttendanceRecap(int branchId, String date);

  //Leave
  Future<LeaveRequestResponse> getLeaveRequests();
  Future<LeaveQuotaResponse> getLeaveQuota();
  Future<LeaveHistoryResponse> getLeaveHistory();

  //Permission
   Future<PermissionQuotaResponse> getPermissionQuota();
   Future<PermissionRequestResponse> getPermissionRequests();
   Future<PermissionHistoryResponse> fetchPermissionHistory();

   //Overtime
   Future<OvertimeRequestResponse> getOvertimeRequests();
   Future<OvertimeHistoryResponse> fetchOvertimeHistory();

   //Salary
   Future<SalarySlipsResponse> getSalarySlips(int year);
  Future<SalarySlipDetail> getSalarySlipDetail(int slipId);

  //Submission
  Future<List<EmployeeSubmission>> getPendingSubmissions(int branchId);
  Future<List<EmployeeSubmission>> getApprovedSubmissions(int branchId);
  Future<List<EmployeeSubmission>> getRejectedSubmissions(int branchId);
   

   //Candidate Submission
  Future<List<CandidateSubmission>> getCandidateSubmissionsPending(int branchId);
  Future<List<CandidateSubmission>> getCandidateSubmissionsApproved(int branchId);
  Future<List<CandidateSubmission>> getCandidateSubmissionsRejected(int branchId);

}




class HRDRemoteDataSourceImpl implements HRDRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  HRDRemoteDataSourceImpl({required this.client});


   @override
  Future<List<CandidateSubmission>> getCandidateSubmissionsPending(int branchId) async {
    final url = '${URLs.baseUrlMock}/candidate-submissions/pending?branch_id=$branchId';
    final response = await client.get(Uri.parse(url), headers: _buildHeaders()).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((submission) => CandidateSubmission.fromJson(submission)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CandidateSubmission>> getCandidateSubmissionsApproved(int branchId) async {
    final url = '${URLs.baseUrlMock}/candidate-submissions/approved?branch_id=$branchId';
    final response = await client.get(Uri.parse(url), headers: _buildHeaders()).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((submission) => CandidateSubmission.fromJson(submission)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CandidateSubmission>> getCandidateSubmissionsRejected(int branchId) async {
    final url = '${URLs.baseUrlMock}/candidate-submissions/rejected?branch_id=$branchId';
    final response = await client.get(Uri.parse(url), headers: _buildHeaders()).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((submission) => CandidateSubmission.fromJson(submission)).toList();
    } else {
      throw ServerException();
    }
  }
  
@override
  Future<List<EmployeeSubmission>> getPendingSubmissions(int branchId) async {
    const url = '${URLs.baseUrlMock}/employee-submissions/pending-approval';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {'branch_id': branchId.toString()}),
      headers: _buildHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> submissionsData = jsonResponse['data'];
      return submissionsData.map((json) => EmployeeSubmission.fromJson(json)).toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

   @override
  Future<List<EmployeeSubmission>> getApprovedSubmissions(int branchId) async {
    const url = '${URLs.baseUrlMock}/employee-submissions/approved';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {'branch_id': branchId.toString()}),
      headers: _buildHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> submissionsData = jsonResponse['data'];
      return submissionsData.map((json) => EmployeeSubmission.fromJson(json)).toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<EmployeeSubmission>> getRejectedSubmissions(int branchId) async {
    const url = '${URLs.baseUrlMock}/employee-submissions/rejected';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {'branch_id': branchId.toString()}),
      headers: _buildHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> submissionsData = jsonResponse['data'];
      return submissionsData.map((json) => EmployeeSubmission.fromJson(json)).toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

   @override
  Future<SalarySlipDetail> getSalarySlipDetail(int slipId) async {
    final url = '${URLs.baseUrlMock}/salary-slip-details';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'slip_id': slipId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SalarySlipDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


    @override
  Future<SalarySlipsResponse> getSalarySlips(int year) async {
    final url = '${URLs.baseUrlMock}/salary-slips?year=$year';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SalarySlipsResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<AttendanceRecap> getAttendanceRecap(int branchId, String date) async {
    const url = '${URLs.baseUrlMock}/attendance-recap';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'date': date,
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AttendanceRecap.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<OvertimeHistoryResponse> fetchOvertimeHistory() async {
    const url = '${URLs.baseUrlMock}/overtime-history';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return OvertimeHistoryResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<OvertimeRequestResponse> getOvertimeRequests() async {
    const url = '${URLs.baseUrlMock}/overtime-requests';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return OvertimeRequestResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PermissionHistoryResponse> fetchPermissionHistory() async {
    const url = '${URLs.baseUrlMock}/permission-history';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PermissionHistoryResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PermissionRequestResponse> getPermissionRequests() async {
    const url = '${URLs.baseUrlMock}/permission-requests';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PermissionRequestResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }
  
@override
  Future<PermissionQuotaResponse> getPermissionQuota() async {
    const url = '${URLs.baseUrlMock}/permission-quota';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PermissionQuotaResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<LeaveHistoryResponse> getLeaveHistory() async {
    const url = '${URLs.baseUrlMock}/leave-history';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return LeaveHistoryResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }



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
  Future<HRDSummaryResponse> getHRDSummary(int branchId) async {
    final url = '${URLs.baseUrlMock}/hrd-summary';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return HRDSummaryResponse.fromJson(jsonResponse['data']);
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
