import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionListCubit extends Cubit<TransactionReportState> {
  final AccountingRepository repository;

  TransactionListCubit({required this.repository}) : super(TransactionReportInitial());

  void fetchTop10Transactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  }) async {
    emit(TransactionReportLoading());

    final result = await repository.getTopTransactions(
      branchId: branchId,
      companyId: companyId,
      employeeId: employeeId,
      date: date,
    );

    result.fold(
      (failure) {
        emit(TransactionReportError(failure is GeneralFailure ? failure.message : 'Failed to fetch top transactions.'));
      },
      (transactions) {
        emit(Top10TransactionsSuccess(transactions.data));
      },
    );
  }

  void fetchDiscountTransactions({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  }) async {
    emit(TransactionReportLoading());

    final result = await repository.getDiscountTransactions(
      branchId: branchId,
      companyId: companyId,
      employeeId: employeeId,
      date: date,
    );

    result.fold(
      (failure) {
        emit(TransactionReportError(failure is GeneralFailure ? failure.message : 'Failed to fetch discount transactions.'));
      },
      (transactions) {
        emit(DiscountTransactionsSuccess(transactions.data));
      },
    );
  }
}
