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
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_type.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/submit_overtime.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_history.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_quota.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/check_in_out_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_quota.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_type.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/submit_permission_request.dart';
import 'package:akib_pos/features/hrd/data/models/attenddance_recap.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/administration/employee_rules.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/administration/employee_warning.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/hrd_all_employee.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/employee_performance.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/submit_employee_request.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_training.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/detail_employee_task_response.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/employee_tasking.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/submit_employee_tasking_request.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_task_detail.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_tasking_model.dart';
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
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/performance_metric_model.dart';
import 'package:akib_pos/features/hrd/data/models/subordinate_employee.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;


abstract class HRDRemoteDataSource {
  Future<HRDSummaryResponse> getHRDSummary(int branchId);
  Future<List<SubordinateEmployeeModel>> getAllSubordinateEmployees(int branchId);


  //HRDPage
  //Attendance
  Future<CheckInOutResponse> checkIn(CheckInOutRequest request);
  Future<CheckInOutResponse> checkOut(CheckInOutRequest request);
  Future<AttendanceHistoryResponse> getAttendanceHistory();
  Future<AttendanceRecap> getAttendanceRecap(  int branchId, 
    int employeeId,  // Add employeeId as a parameter
    String date,);

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
  Future<void> submitPermissionRequest(SubmitPermissionRequest request);
  Future<List<PermissionType>> fetchPermissionTypes();

   //Overtime
  Future<OvertimeRequestResponse> getOvertimeRequests();
  Future<OvertimeHistoryResponse> fetchOvertimeHistory();
  Future<void> submitOvertimeRequest(SubmitOvertimeRequest request);
  Future<List<OvertimeType>> getOvertimeTypes();
  

   //Salary
  Future<SalarySlipsResponse> getSalarySlips(int year);
  Future<SalarySlipDetail> getSalarySlipDetail(int month,int year);


  //Employee Service
  Future<List<HRDAllEmployee>> getAllEmployees(int branchId);
  Future<ContractEmployeeDetail> getContractEmployeeDetail(int employeeId);
  Future<PermanentEmployeeDetail> getPermanentEmployeeDetail(int employeeId);
  Future<List<EmployeePerformance>> getEmployeePerformance(int branchId, String month, String year);
  Future<void> submitEmployeePerformance(SubmitEmployeePerformanceRequest request);
  Future<List<PerformanceMetricModel>> getPerformanceMetrics();
  //administration
  Future<List<EmployeeWarning>> getEmployeeWarnings();
  Future<EmployeeSOPResponse> getEmployeeSOP();
  Future<CompanyRulesResponse> getCompanyRules();
  //training
  Future<EmployeeTrainingResponse> getEmployeeTrainings(int branchId);
  //tasking
  Future<List<EmployeeTask>> fetchEmployeeTasks();
  Future<List<SubordinateTaskModel>> getSubordinateTasks({
    required int branchId,
    required String status,
  });
  Future<SubordinateTaskDetail> getDetailSubordinateTask(int taskingId);
  Future<DetailEmployeeTaskResponse> getDetailEmployeeTask(int taskingId);
  Future<void> submitEmployeeTasking(SubmitEmployeeTaskingRequest request);




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
  Future<List<SubordinateEmployeeModel>> getAllSubordinateEmployees(int branchId) async {
    final url = '${URLs.baseUrlProd}/hrd-all-subordinate-employee?branch_id=$branchId';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List employees = jsonResponse['data'];
      return employees.map((e) => SubordinateEmployeeModel.fromJson(e)).toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException('Failed to fetch subordinate employees');
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> submitEmployeeTasking(SubmitEmployeeTaskingRequest request) async {
    const url = '${URLs.baseUrlProd}/submit-employee-task';

    var httpRequest = http.MultipartRequest('POST', Uri.parse(url));
    httpRequest.headers.addAll(_buildHeaders());

    // Add form-data fields
    httpRequest.fields.addAll(request.toFormData());

    // Add file if exists
    if (request.attachmentPath != null) {
      var file = await http.MultipartFile.fromPath('attachment', request.attachmentPath!);
      httpRequest.files.add(file);
    }

    var response = await httpRequest.send().timeout(const Duration(seconds: 30));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException('Failed to submit employee tasking');
    } else {
      throw ServerException();
    }
  }




  @override
  Future<DetailEmployeeTaskResponse> getDetailEmployeeTask(int taskingId) async {
    final url = '${URLs.baseUrlProd}/detail-employee-task';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'tasking_id': taskingId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)['data'];
      return DetailEmployeeTaskResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<SubordinateTaskDetail> getDetailSubordinateTask(int taskingId) async {
    final url = '${URLs.baseUrlProd}/detail-subordinate-task';
    final response = await client.get(
      Uri.parse('$url?tasking_id=$taskingId'),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SubordinateTaskDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SubordinateTaskModel>> getSubordinateTasks({
    required int branchId,
    required String status,
  }) async {
    const url = '${URLs.baseUrlProd}/subordinate-task';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'status': status,
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((task) => SubordinateTaskModel.fromJson(task)).toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<List<EmployeeTask>> fetchEmployeeTasks() async {
    const url = '${URLs.baseUrlProd}/employee-task';

    final response = await client.get(Uri.parse(url), headers: _buildHeaders());

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse['data'] as List)
          .map((task) => EmployeeTask.fromJson(task))
          .toList();
    } else {
      throw ServerException();
    }
  }


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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      // Handle error
      throw GeneralException('Failed to submit leave request');
    } else {
      throw ServerException();
    }
  }


   @override
  Future<EmployeeTrainingResponse> getEmployeeTrainings(int branchId) async {
    final url = '${URLs.baseUrlProd}/employee-training?branch_id=$branchId';
    final response = await client.get(Uri.parse(url), headers: _buildHeaders());

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return EmployeeTrainingResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<CompanyRulesResponse> getCompanyRules() async {
    const url = '${URLs.baseUrlProd}/company-rules';
    final response = await client.get(Uri.parse(url), headers: _buildHeaders());

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return CompanyRulesResponse.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<EmployeeSOPResponse> getEmployeeSOP() async {
    const url = '${URLs.baseUrlProd}/employee-sop'; // URL endpoint yang sesuai
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return EmployeeSOPResponse.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<List<EmployeeWarning>> getEmployeeWarnings() async {
    const url = '${URLs.baseUrlProd}/employee-warnings';

    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> warnings = jsonResponse['data'];
      return warnings.map((json) => EmployeeWarning.fromJson(json)).toList();
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PerformanceMetricModel>> getPerformanceMetrics() async {
    const url = '${URLs.baseUrlProd}/performance-metrics';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> metricsList = jsonResponse['data'];
      return metricsList
          .map((json) => PerformanceMetricModel.fromJson(json))
          .toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }



  @override
  Future<void> submitEmployeePerformance(SubmitEmployeePerformanceRequest request) async {
    const url = '${URLs.baseUrlProd}/submit-employee-performance';

    final response = await client.post(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: json.encode(request.toJson()),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 201 ) {
       return;
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


   @override
  Future<List<EmployeePerformance>> getEmployeePerformance(int branchId, String month, String year) async {
    const url = '${URLs.baseUrlProd}/employee-performance';
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }



  @override
  Future<ContractEmployeeDetail> getContractEmployeeDetail(int employeeId) async {
    const url = '${URLs.baseUrlProd}/employee/contract/details';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {'employee_id': employeeId.toString()}),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ContractEmployeeDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PermanentEmployeeDetail> getPermanentEmployeeDetail(int employeeId) async {
    const url = '${URLs.baseUrlProd}/employee/permanent/details';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {'employee_id': employeeId.toString()}),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PermanentEmployeeDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }



  @override
  Future<List<HRDAllEmployee>> getAllEmployees(int branchId) async {
    const url = '${URLs.baseUrlProd}/hrd-all-employee';
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<void> verifyCandidateSubmission(VerifyCandidateSubmissionRequest request) async {
    const url = '${URLs.baseUrlProd}/candidate-submissions/verify';
    final response = await client
        .post(
          Uri.parse(url),
          headers: _buildHeaders(),
          body: json.encode(request.toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 201) {
      final errorResponse = json.decode(response.body);
      if (response.statusCode >= 400 && response.statusCode <= 500) {
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

@override
  Future<ContractSubmissionDetail> getContractSubmissionDetail(int candidateSubmissionId) async {
    const url = '${URLs.baseUrlProd}/candidate-submission-detail/contract';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'candidate_id': candidateSubmissionId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ContractSubmissionDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PermanentSubmissionDetail> getPermanentSubmissionDetail(int candidateSubmissionId) async {
    const url = '${URLs.baseUrlProd}/candidate-submission-detail/permanent';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'candidate_id': candidateSubmissionId.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PermanentSubmissionDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

   @override
  Future<List<CandidateSubmission>> getCandidateSubmissionsPending(int branchId) async {
    final url = '${URLs.baseUrlProd}/candidate-submissions/pending?branch_id=$branchId';
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
    final url = '${URLs.baseUrlProd}/candidate-submissions/approved?branch_id=$branchId';
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
    final url = '${URLs.baseUrlProd}/candidate-submissions/rejected?branch_id=$branchId';
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

   @override
  Future<SalarySlipDetail> getSalarySlipDetail(int month,int year) async {
    final url = '${URLs.baseUrlProd}/salary-slips';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'month': month.toString(),
        'year': year.toString(),
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SalarySlipDetail.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


    @override
  Future<SalarySlipsResponse> getSalarySlips(int year) async {
    final url = '${URLs.baseUrlProd}/salary-slips?year=$year';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SalarySlipsResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
   Future<AttendanceRecap> getAttendanceRecap(int branchId, int employeeId, String date) async {
    const url = '${URLs.baseUrlProd}/attendance-recap';
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: {
        'branch_id': branchId.toString(),
        'employee_id': employeeId.toString(),  // Add employeeId to the query params
        'date': date,
      }),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AttendanceRecap.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
    }

  @override
  Future<List<OvertimeType>> getOvertimeTypes() async {
    const url = '${URLs.baseUrlProd}/overtime-type';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> overtimeTypesJson = jsonResponse['data'];
      return overtimeTypesJson.map((json) => OvertimeType.fromJson(json)).toList();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> submitOvertimeRequest(SubmitOvertimeRequest request) async {
    const url = '${URLs.baseUrlProd}/overtime-request';

    var multipartRequest = http.MultipartRequest('POST', Uri.parse(url));
    multipartRequest.headers.addAll(_buildHeaders());

    // Add form-data fields
    multipartRequest.fields.addAll(request.toFormData());

    // Add file if exists
    if (request.attachmentPath != null) {
      var file = await http.MultipartFile.fromPath('attachment', request.attachmentPath!);
      multipartRequest.files.add(file);
    }

    var response = await multipartRequest.send().timeout(const Duration(seconds: 30));

    if (response.statusCode == 201) {
      // Success
      return;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException('Failed to submit overtime request');
    } else {
      throw ServerException();
    }
  }


  @override
  Future<OvertimeHistoryResponse> fetchOvertimeHistory() async {
    const url = '${URLs.baseUrlProd}/overtime-history';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return OvertimeHistoryResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<OvertimeRequestResponse> getOvertimeRequests() async {
    const url = '${URLs.baseUrlProd}/overtime-requests';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return OvertimeRequestResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

   @override
  Future<List<PermissionType>> fetchPermissionTypes() async {
    const url = '${URLs.baseUrlProd}/permission-type';
    
    final response = await client.get(Uri.parse(url), headers: _buildHeaders());

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse['data'] as List)
          .map((permissionType) => PermissionType.fromJson(permissionType))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> submitPermissionRequest(SubmitPermissionRequest request) async {
    const url = '${URLs.baseUrlProd}/permission-request';

    var multipartRequest = http.MultipartRequest('POST', Uri.parse(url));
    multipartRequest.headers.addAll(_buildHeaders());

    // Tambahkan form-data fields
    multipartRequest.fields.addAll(request.toFormData());

    // Tambahkan file jika ada
    if (request.attachmentPath != null) {
      var file = await http.MultipartFile.fromPath('attachment', request.attachmentPath!);
      multipartRequest.files.add(file);
    }

    var response = await multipartRequest.send().timeout(const Duration(seconds: 30));

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException('Gagal mengirim permintaan izin');
    } else {
      throw ServerException();
    }
  }


  @override
  Future<PermissionHistoryResponse> fetchPermissionHistory() async {
    const url = '${URLs.baseUrlProd}/permission-history';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PermissionHistoryResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PermissionRequestResponse> getPermissionRequests() async {
    const url = '${URLs.baseUrlProd}/permission-requests';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PermissionRequestResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }
  
@override
  Future<PermissionQuotaResponse> getPermissionQuota() async {
    const url = '${URLs.baseUrlProd}/permission-quota';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PermissionQuotaResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<AttendanceHistoryResponse> getAttendanceHistory() async {
    // No parameters required
    const url = '${URLs.baseUrlProd}/attendance-history';
    final response = await client
        .get(
          Uri.parse(url),
          headers: _buildHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AttendanceHistoryResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
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
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CheckInOutResponse> checkIn(CheckInOutRequest request) async {
    const url = '${URLs.baseUrlProd}/check-in';
    final response = await client
        .post(
          Uri.parse(url),
          headers: _buildHeaders(),
          body: json.encode(request.toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return CheckInOutResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CheckInOutResponse> checkOut(CheckInOutRequest request) async {
    const url = '${URLs.baseUrlProd}/check-out';
    final response = await client
        .post(
          Uri.parse(url),
          headers: _buildHeaders(),
          body: json.encode(request.toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return CheckInOutResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
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
