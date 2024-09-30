import 'dart:convert';
import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/attendance_history_item.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_history.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_request_data.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_type.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_history.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_history.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_quota.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/check_in_out_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_quota.dart';
import 'package:akib_pos/features/hrd/data/models/attenddance_recap.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/administration/company_rules.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/administration/employee_warning.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/hrd_all_employee.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/employee_performance.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/submit_employee_request.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_training.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/candidate_submission.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/salary/salary_slip.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/salary/salary_slip_detail.dart';
import 'package:akib_pos/features/hrd/data/models/hrd_summary.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/permanent_submission_detail_model.dart';
import 'package:akib_pos/features/hrd/data/models/submission/employee/employee_submission.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/contract_submission_detail_model.dart.dart';
import 'package:akib_pos/features/hrd/data/models/submission/employee/verify_employee_submission_request.dart';
import 'package:akib_pos/features/hrd/data/models/submission/employee/verify_employee_submission_response.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/verify_candidate_submission_request.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/contract_employee_detail.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/permanent_employee_detail.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/administration/employee_sop.dart';
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
  Future<void> submitLeaveRequest(LeaveRequest leaveRequest);
  Future<List<LeaveType>> getLeaveTypes();

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


  //Employee Service
  Future<List<HRDAllEmployee>> getAllEmployees(int branchId);
  Future<ContractEmployeeDetail> getContractEmployeeDetail(int employeeId);
  Future<PermanentEmployeeDetail> getPermanentEmployeeDetail(int employeeId);
  Future<List<EmployeePerformance>> getEmployeePerformance(int branchId, String month, String year);
  Future<void> submitEmployeePerformance(SubmitEmployeePerformanceRequest request);
  //administration
  Future<List<EmployeeWarning>> getEmployeeWarnings();
  Future<EmployeeSOPResponse> getEmployeeSOP();
  Future<CompanyRulesResponse> getCompanyRules();
  //training
  Future<EmployeeTrainingResponse> getEmployeeTrainings(int branchId);



  //Submission
  Future<List<EmployeeSubmission>> getPendingSubmissions(int branchId);
  Future<List<EmployeeSubmission>> getApprovedSubmissions(int branchId);
  Future<List<EmployeeSubmission>> getRejectedSubmissions(int branchId);
  Future<VerifyEmployeeSubmissionResponse> verifyEmployeeSubmission(VerifyEmployeeSubmissionRequest request);
   

   //Candidate Submission
  Future<List<CandidateSubmission>> getCandidateSubmissionsPending(int branchId);
  Future<List<CandidateSubmission>> getCandidateSubmissionsApproved(int branchId);
  Future<List<CandidateSubmission>> getCandidateSubmissionsRejected(int branchId);
  Future<ContractSubmissionDetail> getContractSubmissionDetail(int candidateSubmissionId);
  Future<PermanentSubmissionDetail> getPermanentSubmissionDetail(int candidateSubmissionId);
  Future<void> verifyCandidateSubmission(VerifyCandidateSubmissionRequest request);

}




class HRDRemoteDataSourceImpl implements HRDRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  HRDRemoteDataSourceImpl({required this.client});


   @override
  Future<void> submitLeaveRequest(LeaveRequest leaveRequest) async {
    const url = '${URLs.baseUrlProd}/leave-request';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(_buildHeaders());

    // Add form-data fields
    request.fields.addAll(leaveRequest.toFormData());

    // Add file if exists
    if (leaveRequest.attachmentPath != null) {
      var file = await http.MultipartFile.fromPath('attachment', leaveRequest.attachmentPath!);
      request.files.add(file);
    }

    var response = await request.send().timeout(const Duration(seconds: 30));

    if (response.statusCode == 201) {
      // Success
      return;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      // Handle error
      throw GeneralException('Failed to submit leave request');
    } else {
      throw ServerException();
    }
  }


   @override
  Future<EmployeeTrainingResponse> getEmployeeTrainings(int branchId) async {
    final url = '${URLs.baseUrlMock}/employee-training?branch_id=$branchId';
    final response = await client.get(Uri.parse(url), headers: _buildHeaders());

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return EmployeeTrainingResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<CompanyRulesResponse> getCompanyRules() async {
    const url = '${URLs.baseUrlMock}/company-rules';
    final response = await client.get(Uri.parse(url), headers: _buildHeaders());

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return CompanyRulesResponse.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<EmployeeSOPResponse> getEmployeeSOP() async {
    const url = '${URLs.baseUrlMock}/employee-sop'; // URL endpoint yang sesuai
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return EmployeeSOPResponse.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<List<EmployeeWarning>> getEmployeeWarnings() async {
    const url = '${URLs.baseUrlMock}/employee-warnings';

    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> warnings = jsonResponse['data'];
      return warnings.map((json) => EmployeeWarning.fromJson(json)).toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<void> submitEmployeePerformance(SubmitEmployeePerformanceRequest request) async {
    const url = '${URLs.baseUrlMock}/submit-employee-performance';

    final response = await client.post(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: json.encode(request.toJson()),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] != 'success') {
        throw GeneralException(jsonResponse['message']);
      }
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


   @override
  Future<List<EmployeePerformance>> getEmployeePerformance(int branchId, String month, String year) async {
    const url = '${URLs.baseUrlMock}/employee-performance';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'month': month,
        'year': year,
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<EmployeePerformance> employeePerformances = (jsonResponse['data'] as List)
          .map((employee) => EmployeePerformance.fromJson(employee))
          .toList();
      return employeePerformances;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }



  @override
  Future<ContractEmployeeDetail> getContractEmployeeDetail(int employeeId) async {
    const url = '${URLs.baseUrlMock}/employee/contract/details';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {'employee_id': employeeId.toString()}),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ContractEmployeeDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PermanentEmployeeDetail> getPermanentEmployeeDetail(int employeeId) async {
    const url = '${URLs.baseUrlMock}/employee/permanent/details';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {'employee_id': employeeId.toString()}),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PermanentEmployeeDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }



  @override
  Future<List<HRDAllEmployee>> getAllEmployees(int branchId) async {
    const url = '${URLs.baseUrlMock}/hrd-all-employee';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {'branch_id': branchId.toString()}),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<HRDAllEmployee> employeeList = (jsonResponse['data'] as List)
          .map((employee) => HRDAllEmployee.fromJson(employee))
          .toList();
      return employeeList;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<void> verifyCandidateSubmission(VerifyCandidateSubmissionRequest request) async {
    const url = '${URLs.baseUrlMock}/candidate-submissions/verify';
    final response = await client
        .post(
          Uri.parse(url),
          headers: _buildHeaders(),
          body: json.encode(request.toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 201) {
      final errorResponse = json.decode(response.body);
      if (response.statusCode >= 400 && response.statusCode < 500) {
        throw GeneralException(errorResponse['message']);
      } else {
        throw ServerException();
      }
    }
  }


  @override
  Future<VerifyEmployeeSubmissionResponse> verifyEmployeeSubmission(VerifyEmployeeSubmissionRequest request) async {
    const url = '${URLs.baseUrlProd}/employee-submissions/verify';
    final response = await client
        .post(
          Uri.parse(url),
          headers: _buildHeaders(),
          body: json.encode(request.toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return VerifyEmployeeSubmissionResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

@override
  Future<ContractSubmissionDetail> getContractSubmissionDetail(int candidateSubmissionId) async {
    const url = '${URLs.baseUrlMock}/candidate-submission-detail/contract';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'candidate_submission_id': candidateSubmissionId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ContractSubmissionDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PermanentSubmissionDetail> getPermanentSubmissionDetail(int candidateSubmissionId) async {
    const url = '${URLs.baseUrlMock}/candidate-submission-detail/permanent';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'candidate_submission_id': candidateSubmissionId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PermanentSubmissionDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

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
    const url = '${URLs.baseUrlProd}/employee-submissions/pending-approval';
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
    const url = '${URLs.baseUrlProd}/employee-submissions/approved';
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
    const url = '${URLs.baseUrlProd}/employee-submissions/rejected';
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
    const url = '${URLs.baseUrlProd}/leave-history';
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
    const url = '${URLs.baseUrlProd}/leave-requests';
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
    const url = '${URLs.baseUrlProd}/leave-quota';
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
  Future<List<LeaveType>> getLeaveTypes() async {
    const url = '${URLs.baseUrlProd}/leave-type';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> leaveTypeList = jsonResponse['data'];
      return leaveTypeList.map((json) => LeaveType.fromJson(json)).toList();
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
    const url = '${URLs.baseUrlProd}/hrd-summary';
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
