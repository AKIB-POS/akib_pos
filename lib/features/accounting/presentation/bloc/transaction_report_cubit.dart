import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report_model.dart';
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
        if (failure is GeneralFailure) {
          emit(TransactionReportError(failure.message));
        } else {
          emit(TransactionReportError('Failed to fetch transaction report.'));
        }
      },
      (report) {
        emit(TransactionReportSuccess(report));
      },
    );
  }
}

abstract class TransactionReportState {}

class TransactionReportInitial extends TransactionReportState {}

class TransactionReportLoading extends TransactionReportState {}

class TransactionReportSuccess extends TransactionReportState {
  final TransactionReportModel report;

  TransactionReportSuccess(this.report);
}

class TransactionReportError extends TransactionReportState {
  final String message;

  TransactionReportError(this.message);
}
