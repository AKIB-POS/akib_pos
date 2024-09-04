import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/accounting_transaction_reporrt_model.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/transaction_report_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionReportCubit extends Cubit<TransactionReportState> {
  final AccountingRepository repository;

  TransactionReportCubit({required this.repository}) : super(TransactionReportInitial());

  void fetchTodayTransactionReport({
    required int branchId,
    required int companyId,
    required int employeeId,
    required String date,
  }) async {
    emit(TransactionReportLoading());

    final result = await repository.getTodayTransactionReport(
      branchId: branchId,
      companyId: companyId,
      employeeId: employeeId,
      date: date,
    );

    result.fold(
      (failure) {
        emit(TransactionReportError(failure is GeneralFailure ? failure.message : 'Failed to fetch transaction report.'));
      },
      (report) {
        emit(TodayTransactionReportSuccess(report));
      },
    );
  }
}

abstract class TransactionReportState {}

class TransactionReportInitial extends TransactionReportState {}

class TransactionReportLoading extends TransactionReportState {}

class TodayTransactionReportSuccess extends TransactionReportState {
  final TransactionReportModel report;

  TodayTransactionReportSuccess(this.report);
}

class Top10TransactionsSuccess extends TransactionReportState {
  final List<AccountingTransactionReportModel> transactions;

  Top10TransactionsSuccess(this.transactions);
}

class DiscountTransactionsSuccess extends TransactionReportState {
  final List<AccountingTransactionReportModel> transactions;

  DiscountTransactionsSuccess(this.transactions);
}

class TransactionReportError extends TransactionReportState {
  final String message;

  TransactionReportError(this.message);
}
