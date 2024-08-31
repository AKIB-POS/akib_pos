import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/datasources/accounting_remote_data_source.dart';
import 'package:akib_pos/features/accounting/data/models/transcation_summary_response.dart';
import 'package:dartz/dartz.dart';

abstract class AccountingRepository {
  Future<Either<Failure, TransactionSummaryResponse>> getTodayTransactionSummary(int branchId, int companyId);
}

class AccountingRepositoryImpl implements AccountingRepository {
  final AccountingRemoteDataSource remoteDataSource;

  AccountingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TransactionSummaryResponse>> getTodayTransactionSummary(int branchId, int companyId) async {
    try {
      final response = await remoteDataSource.getTodayTransactionSummary(branchId, companyId);
      return Right(response);
    } catch (e) {
      if (e is GeneralException) {
        return Left(GeneralFailure(e.message));
      } else if (e is ServerException) {
        return Left(ServerFailure());
      } else {
        return Left(GeneralFailure("Unexpected error occurred"));
      }
    }
  }
}
