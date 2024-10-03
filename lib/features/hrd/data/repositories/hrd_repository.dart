import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/datasources/remote/hrd_remote_data_source.dart';
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
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/employee_tasking.dart';
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
import 'package:dartz/dartz.dart';

abstract class HRDRepository {
  //HRDPage
  Future<Either<Failure, HRDSummaryResponse>> getHRDSummary(int branchId);

  //Attendance
  Future<Either<Failure, CheckInOutResponse>> checkIn(
      CheckInOutRequest request);
  Future<Either<Failure, CheckInOutResponse>> checkOut(
      CheckInOutRequest request);
  Future<Either<Failure, AttendanceHistoryResponse>> getAttendanceHistory();
  Future<Either<Failure, AttendanceRecap>> getAttendanceRecap(
      int branchId, String date);

  //Leave
  Future<Either<Failure, LeaveQuotaResponse>> getLeaveQuota();
  Future<Either<Failure, LeaveRequestResponse>> getLeaveRequests();
  Future<Either<Failure, LeaveHistoryResponse>> getLeaveHistory();
  Future<Either<Failure, void>> submitLeaveRequest(LeaveRequest leaveRequest);
  Future<Either<Failure, List<LeaveType>>> getLeaveTypes();

  //Permission
  Future<Either<Failure, PermissionQuotaResponse>> getPermissionQuota();
  Future<Either<Failure, PermissionRequestResponse>> getPermissionRequests();
  Future<Either<Failure, PermissionHistoryResponse>> getPermissionHistory();
  Future<void> submitPermissionRequest(SubmitPermissionRequest request);
  Future<Either<Failure, List<PermissionType>>> fetchPermissionTypes();

  //Overtime
  Future<Either<Failure, OvertimeRequestResponse>> getOvertimeRequests();
  Future<Either<Failure, OvertimeHistoryResponse>> fetchOvertimeHistory();
  Future<Either<Failure, void>> submitOvertimeRequest(SubmitOvertimeRequest request);
   Future<Either<Failure, List<OvertimeType>>> getOvertimeTypes();

  //Salary
  Future<Either<Failure, SalarySlipsResponse>> getSalarySlips(int year);
  Future<Either<Failure, SalarySlipDetail>> getSalarySlipDetail(int month, int year);

  //Employee
  Future<Either<Failure, List<HRDAllEmployee>>> getAllEmployees(int branchId);
  Future<Either<Failure, ContractEmployeeDetail>> getContractEmployeeDetail(
      int employeeId);
  Future<Either<Failure, PermanentEmployeeDetail>> getPermanentEmployeeDetail(
      int employeeId);
  Future<Either<Failure, List<EmployeePerformance>>> getEmployeePerformance(int branchId, String month, String year);
  Future<Either<Failure, void>> submitEmployeePerformance(SubmitEmployeePerformanceRequest request);
  Future<Either<Failure, List<PerformanceMetricModel>>> getPerformanceMetrics();
  //administration
  Future<Either<Failure, List<EmployeeWarning>>> getEmployeeWarnings();
  Future<Either<Failure, EmployeeSOPResponse>> getEmployeeSOP();
  Future<Either<Failure, CompanyRulesResponse>> getCompanyRules();
  //training
  Future<Either<Failure, EmployeeTrainingResponse>> getEmployeeTrainings(int branchId);
  //Tasking
  Future<Either<Failure, List<EmployeeTask>>> fetchEmployeeTasks();
  Future<Either<Failure, List<SubordinateTaskModel>>> getSubordinateTasks({
    required int branchId,
    required String status,
  });
  Future<Either<Failure, SubordinateTaskDetail>> getDetailSubordinateTask(int taskingId);

  //Employee Submission
  Future<Either<Failure, List<EmployeeSubmission>>> getPendingSubmissions(
      int branchId);
  Future<Either<Failure, List<EmployeeSubmission>>> getApprovedSubmissions(
      int branchId);
  Future<Either<Failure, List<EmployeeSubmission>>> getRejectedSubmissions(
      int branchId);
  Future<Either<Failure, VerifyEmployeeSubmissionResponse>>
      verifyEmployeeSubmission(VerifyEmployeeSubmissionRequest request);
    

  //CandidateSubmission
  Future<Either<Failure, List<CandidateSubmission>>>
      getCandidateSubmissionsPending(int branchId);
  Future<Either<Failure, List<CandidateSubmission>>>
      getCandidateSubmissionsApproved(int branchId);
  Future<Either<Failure, List<CandidateSubmission>>>
      getCandidateSubmissionsRejected(int branchId);
  Future<Either<Failure, ContractSubmissionDetail>> getContractSubmissionDetail(
      int candidateSubmissionId);
  Future<Either<Failure, PermanentSubmissionDetail>>
      getPermanentSubmissionDetail(int candidateSubmissionId);
  Future<Either<Failure, void>> verifyCandidateSubmission(
      VerifyCandidateSubmissionRequest request);
}

class HRDRepositoryImpl implements HRDRepository {
  final HRDRemoteDataSource remoteDataSource;

  HRDRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Either<Failure, SubordinateTaskDetail>> getDetailSubordinateTask(int taskingId) async {
    try {
      final detail = await remoteDataSource.getDetailSubordinateTask(taskingId);
      return Right(detail);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<SubordinateTaskModel>>> getSubordinateTasks({
    required int branchId,
    required String status,
  }) async {
    try {
      final tasks = await remoteDataSource.getSubordinateTasks(
        branchId: branchId,
        status: status,
      );
      return Right(tasks);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<EmployeeTask>>> fetchEmployeeTasks() async {
    try {
      final tasks = await remoteDataSource.fetchEmployeeTasks();
      return Right(tasks);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }



  @override
  Future<Either<Failure, void>> submitLeaveRequest(LeaveRequest leaveRequest) async {
    try {
      await remoteDataSource.submitLeaveRequest(leaveRequest);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


@override
  Future<Either<Failure, EmployeeTrainingResponse>> getEmployeeTrainings(int branchId) async {
    try {
      final trainingData = await remoteDataSource.getEmployeeTrainings(branchId);
      return Right(trainingData);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

@override
  Future<Either<Failure, CompanyRulesResponse>> getCompanyRules() async {
    try {
      final companyRules = await remoteDataSource.getCompanyRules();
      return Right(companyRules);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmployeeSOPResponse>> getEmployeeSOP() async {
    try {
      final employeeSOP = await remoteDataSource.getEmployeeSOP();
      return Right(employeeSOP);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<EmployeeWarning>>> getEmployeeWarnings() async {
    try {
      final warnings = await remoteDataSource.getEmployeeWarnings();
      return Right(warnings);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PerformanceMetricModel>>> getPerformanceMetrics() async {
    try {
      final metrics = await remoteDataSource.getPerformanceMetrics();
      return Right(metrics);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }



  @override
  Future<Either<Failure, void>> submitEmployeePerformance(SubmitEmployeePerformanceRequest request) async {
    try {
  await remoteDataSource.submitEmployeePerformance(request);
  return const Right(null); // Jika sukses, return `Right(null)`
} on ServerException {
  return Left(ServerFailure());
} on GeneralException catch (e) {
  // Pastikan hanya GeneralException yang ditangkap, tanpa menangkap `201`
  return Left(GeneralFailure(e.message));
} catch (e) {
  // Ini adalah tangkapan umum, tapi pastikan ini hanya untuk error yang tidak diharapkan
  return Left(GeneralFailure(e.toString()));
}

  }



  @override
  Future<Either<Failure, List<EmployeePerformance>>> getEmployeePerformance(int branchId, String month, String year) async {
    try {
      final employeePerformances = await remoteDataSource.getEmployeePerformance(branchId, month, year);
      return Right(employeePerformances);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContractEmployeeDetail>> getContractEmployeeDetail(
      int employeeId) async {
    try {
      final employeeDetail =
          await remoteDataSource.getContractEmployeeDetail(employeeId);
      return Right(employeeDetail);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PermanentEmployeeDetail>> getPermanentEmployeeDetail(
      int employeeId) async {
    try {
      final employeeDetail =
          await remoteDataSource.getPermanentEmployeeDetail(employeeId);
      return Right(employeeDetail);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HRDAllEmployee>>> getAllEmployees(
      int branchId) async {
    try {
      final employeeList = await remoteDataSource.getAllEmployees(branchId);
      return Right(employeeList);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyCandidateSubmission(
      VerifyCandidateSubmissionRequest request) async {
    try {
      await remoteDataSource.verifyCandidateSubmission(request);
      return Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyEmployeeSubmissionResponse>>
      verifyEmployeeSubmission(VerifyEmployeeSubmissionRequest request) async {
    try {
      final response = await remoteDataSource.verifyEmployeeSubmission(request);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContractSubmissionDetail>> getContractSubmissionDetail(
      int candidateSubmissionId) async {
    try {
      final contractSubmissionDetail = await remoteDataSource
          .getContractSubmissionDetail(candidateSubmissionId);
      return Right(contractSubmissionDetail);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PermanentSubmissionDetail>>
      getPermanentSubmissionDetail(int candidateSubmissionId) async {
    try {
      final permanentSubmissionDetail = await remoteDataSource
          .getPermanentSubmissionDetail(candidateSubmissionId);
      return Right(permanentSubmissionDetail);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CandidateSubmission>>>
      getCandidateSubmissionsPending(int branchId) async {
    try {
      final submissions =
          await remoteDataSource.getCandidateSubmissionsPending(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CandidateSubmission>>>
      getCandidateSubmissionsApproved(int branchId) async {
    try {
      final submissions =
          await remoteDataSource.getCandidateSubmissionsApproved(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CandidateSubmission>>>
      getCandidateSubmissionsRejected(int branchId) async {
    try {
      final submissions =
          await remoteDataSource.getCandidateSubmissionsRejected(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmployeeSubmission>>> getPendingSubmissions(
      int branchId) async {
    try {
      final submissions =
          await remoteDataSource.getPendingSubmissions(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmployeeSubmission>>> getApprovedSubmissions(
      int branchId) async {
    try {
      final submissions =
          await remoteDataSource.getApprovedSubmissions(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmployeeSubmission>>> getRejectedSubmissions(
      int branchId) async {
    try {
      final submissions =
          await remoteDataSource.getRejectedSubmissions(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SalarySlipDetail>> getSalarySlipDetail(
      int month,int year) async {
    try {
      final salarySlipDetail =
          await remoteDataSource.getSalarySlipDetail(month,year);
      return Right(salarySlipDetail);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SalarySlipsResponse>> getSalarySlips(int year) async {
    try {
      final salarySlips = await remoteDataSource.getSalarySlips(year);
      return Right(salarySlips);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceRecap>> getAttendanceRecap(
      int branchId, String date) async {
    try {
      final attendanceRecap =
          await remoteDataSource.getAttendanceRecap(branchId, date);
      return Right(attendanceRecap);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OvertimeType>>> getOvertimeTypes() async {
    try {
      final overtimeTypes = await remoteDataSource.getOvertimeTypes();
      return Right(overtimeTypes);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitOvertimeRequest(SubmitOvertimeRequest request) async {
    try {
      await remoteDataSource.submitOvertimeRequest(request);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, OvertimeHistoryResponse>>
      fetchOvertimeHistory() async {
    try {
      final overtimeHistory = await remoteDataSource.fetchOvertimeHistory();
      return Right(overtimeHistory);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OvertimeRequestResponse>> getOvertimeRequests() async {
    try {
      final overtimeRequests = await remoteDataSource.getOvertimeRequests();
      return Right(overtimeRequests);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


@override
  Future<Either<Failure, List<PermissionType>>> fetchPermissionTypes() async {
    try {
      final permissionTypes = await remoteDataSource.fetchPermissionTypes();
      return Right(permissionTypes);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
  @override
  Future<void> submitPermissionRequest(SubmitPermissionRequest request) async {
    try {
      await remoteDataSource.submitPermissionRequest(request);
    } on ServerException {
      throw ServerFailure();
    } catch (e) {
      throw GeneralFailure(e.toString());
    }
  }

  @override
  Future<Either<Failure, PermissionHistoryResponse>>
      getPermissionHistory() async {
    try {
      final permissionHistory = await remoteDataSource.fetchPermissionHistory();
      return Right(permissionHistory);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PermissionRequestResponse>>
      getPermissionRequests() async {
    try {
      final permissionRequests = await remoteDataSource.getPermissionRequests();
      return Right(permissionRequests);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PermissionQuotaResponse>> getPermissionQuota() async {
    try {
      final permissionQuota = await remoteDataSource.getPermissionQuota();
      return Right(permissionQuota);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LeaveHistoryResponse>> getLeaveHistory() async {
    try {
      final leaveHistory = await remoteDataSource.getLeaveHistory();
      return Right(leaveHistory);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LeaveRequestResponse>> getLeaveRequests() async {
    try {
      final leaveRequests = await remoteDataSource.getLeaveRequests();
      return Right(leaveRequests);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LeaveQuotaResponse>> getLeaveQuota() async {
    try {
      final leaveQuota = await remoteDataSource.getLeaveQuota();
      return Right(leaveQuota);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeaveType>>> getLeaveTypes() async {
    try {
      final leaveTypes = await remoteDataSource.getLeaveTypes();
      return Right(leaveTypes);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceHistoryResponse>>
      getAttendanceHistory() async {
    // No parameters required
    try {
      final attendanceHistory = await remoteDataSource.getAttendanceHistory();
      return Right(attendanceHistory);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HRDSummaryResponse>> getHRDSummary(
      int branchId) async {
    try {
      final hrdSummary = await remoteDataSource.getHRDSummary(branchId);
      return Right(hrdSummary);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CheckInOutResponse>> checkIn(
      CheckInOutRequest request) async {
    try {
      final checkInResponse = await remoteDataSource.checkIn(request);
      return Right(checkInResponse);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CheckInOutResponse>> checkOut(
      CheckInOutRequest request) async {
    try {
      final checkOutResponse = await remoteDataSource.checkOut(request);
      return Right(checkOutResponse);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
