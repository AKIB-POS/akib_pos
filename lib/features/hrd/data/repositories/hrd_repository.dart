import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/hrd/data/datasources/remote/hrd_remote_data_source.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_summary.dart';
import 'package:dartz/dartz.dart';

abstract class HRDRepository {
  Future<Either<Failure, AttendanceSummaryResponse>> getAttendanceSummary(int branchId, int companyId);
}
class HRDRepositoryImpl implements HRDRepository {
  final HRDRemoteDataSource remoteDataSource;

  HRDRepositoryImpl({required this.remoteDataSource});

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
}

