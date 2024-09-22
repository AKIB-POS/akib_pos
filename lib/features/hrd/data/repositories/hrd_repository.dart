import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/datasources/remote/hrd_remote_data_source.dart';
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
  Future<Either<Failure, AttendanceRecap>> getAttendanceRecap(int branchId, String date);

  //Leave
  Future<Either<Failure, LeaveQuotaResponse>> getLeaveQuota();
  Future<Either<Failure, LeaveRequestResponse>> getLeaveRequests();
  Future<Either<Failure, LeaveHistoryResponse>> getLeaveHistory();

  //Permission
  Future<Either<Failure, PermissionQuotaResponse>> getPermissionQuota();
  Future<Either<Failure, PermissionRequestResponse>> getPermissionRequests();
  Future<Either<Failure, PermissionHistoryResponse>> getPermissionHistory();

  //Overtime
  Future<Either<Failure, OvertimeRequestResponse>> getOvertimeRequests();
  Future<Either<Failure, OvertimeHistoryResponse>> fetchOvertimeHistory();

  //Salary
  Future<Either<Failure, SalarySlipsResponse>> getSalarySlips(int year);
  Future<Either<Failure, SalarySlipDetail>> getSalarySlipDetail(int slipId);

  //Submission
  Future<Either<Failure, List<EmployeeSubmission>>> getPendingSubmissions(int branchId);
  Future<Either<Failure, List<EmployeeSubmission>>> getApprovedSubmissions(int branchId);
  Future<Either<Failure, List<EmployeeSubmission>>> getRejectedSubmissions(int branchId);


  //CandidateSubmission
  Future<Either<Failure, List<CandidateSubmission>>> getCandidateSubmissionsPending(int branchId);
  Future<Either<Failure, List<CandidateSubmission>>> getCandidateSubmissionsApproved(int branchId);
  Future<Either<Failure, List<CandidateSubmission>>> getCandidateSubmissionsRejected(int branchId);
  

}

class HRDRepositoryImpl implements HRDRepository {
  final HRDRemoteDataSource remoteDataSource;

  HRDRepositoryImpl({required this.remoteDataSource});


@override
  Future<Either<Failure, List<CandidateSubmission>>> getCandidateSubmissionsPending(int branchId) async {
    try {
      final submissions = await remoteDataSource.getCandidateSubmissionsPending(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CandidateSubmission>>> getCandidateSubmissionsApproved(int branchId) async {
    try {
      final submissions = await remoteDataSource.getCandidateSubmissionsApproved(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CandidateSubmission>>> getCandidateSubmissionsRejected(int branchId) async {
    try {
      final submissions = await remoteDataSource.getCandidateSubmissionsRejected(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
  


  @override
  Future<Either<Failure, List<EmployeeSubmission>>> getPendingSubmissions(int branchId) async {
    try {
      final submissions = await remoteDataSource.getPendingSubmissions(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmployeeSubmission>>> getApprovedSubmissions(int branchId) async {
    try {
      final submissions = await remoteDataSource.getApprovedSubmissions(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmployeeSubmission>>> getRejectedSubmissions(int branchId) async {
    try {
      final submissions = await remoteDataSource.getRejectedSubmissions(branchId);
      return Right(submissions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, SalarySlipDetail>> getSalarySlipDetail(int slipId) async {
    try {
      final salarySlipDetail = await remoteDataSource.getSalarySlipDetail(slipId);
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
  Future<Either<Failure, AttendanceRecap>> getAttendanceRecap(int branchId, String date) async {
    try {
      final attendanceRecap = await remoteDataSource.getAttendanceRecap(branchId, date);
      return Right(attendanceRecap);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  
 @override
  Future<Either<Failure, OvertimeHistoryResponse>> fetchOvertimeHistory() async {
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
  Future<Either<Failure, PermissionHistoryResponse>> getPermissionHistory() async {
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
  Future<Either<Failure, PermissionRequestResponse>> getPermissionRequests() async {
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
  Future<Either<Failure, HRDSummaryResponse>> getHRDSummary(int branchId) async {
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
