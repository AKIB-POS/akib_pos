import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/datasources/remote/hrd_remote_data_source.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/attendance_history_item.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_request_data.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_summary.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/check_in_out_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_quota.dart';
import 'package:dartz/dartz.dart';

abstract class HRDRepository {
  Future<Either<Failure, AttendanceSummaryResponse>> getAttendanceSummary(int branchId, int companyId);
  Future<Either<Failure, CheckInOutResponse>> checkIn(CheckInOutRequest request);
  Future<Either<Failure, CheckInOutResponse>> checkOut(CheckInOutRequest request);
  Future<Either<Failure, AttendanceHistoryResponse>> getAttendanceHistory();
  Future<Either<Failure, LeaveQuotaResponse>> getLeaveQuota();
  Future<Either<Failure, LeaveRequestResponse>> getLeaveRequests(); 
}

class HRDRepositoryImpl implements HRDRepository {
  final HRDRemoteDataSource remoteDataSource;

  HRDRepositoryImpl({required this.remoteDataSource});
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
  Future<Either<Failure, AttendanceHistoryResponse>> getAttendanceHistory() async { // No parameters required
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
  Future<Either<Failure, AttendanceSummaryResponse>> getAttendanceSummary(int branchId, int companyId) async {
    try {
      final attendanceSummary = await remoteDataSource.getAttendanceSummary(branchId, companyId);
      return Right(attendanceSummary);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CheckInOutResponse>> checkIn(CheckInOutRequest request) async {
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
  Future<Either<Failure, CheckInOutResponse>> checkOut(CheckInOutRequest request) async {
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
