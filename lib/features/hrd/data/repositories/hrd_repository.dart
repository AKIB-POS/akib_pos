import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/datasources/remote/hrd_remote_data_source.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_history_item.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_summary.dart';
import 'package:akib_pos/features/hrd/data/models/check_in_out_request.dart';
import 'package:dartz/dartz.dart';

abstract class HRDRepository {
  Future<Either<Failure, AttendanceSummaryResponse>> getAttendanceSummary(int branchId, int companyId);
  Future<Either<Failure, CheckInOutResponse>> checkIn(CheckInOutRequest request);
  Future<Either<Failure, CheckInOutResponse>> checkOut(CheckInOutRequest request);
  Future<Either<Failure, AttendanceHistoryResponse>> getAttendanceHistory();
}

class HRDRepositoryImpl implements HRDRepository {
  final HRDRemoteDataSource remoteDataSource;

  HRDRepositoryImpl({required this.remoteDataSource});

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
