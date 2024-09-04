import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/transcation_summary_response.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionSummaryCubit extends Cubit<TransactionSummaryState> {
  final AccountingRepository repository;

  TransactionSummaryCubit({required this.repository}) : super(TransactionSummaryInitial());

void fetchTodayTransactionSummary(int branchId, int companyId) async {
  emit(TransactionSummaryLoading());

  final result = await repository.getTodayTransactionSummary(branchId, companyId);

  result.fold(
    (failure) {
      if (failure is GeneralFailure) {
        emit(TransactionSummaryError(failure.message));
      } else {
        emit(TransactionSummaryError('Gagal mengambil data transaksi.'));
      }
    },
    (response) {
      emit(TransactionSummarySuccess(response));
    },
  );
}


  void resetState() {
    emit(TransactionSummaryInitial());
  }
}

abstract class TransactionSummaryState {}

class TransactionSummaryInitial extends TransactionSummaryState {}

class TransactionSummaryLoading extends TransactionSummaryState {}

class TransactionSummarySuccess extends TransactionSummaryState {
  final TransactionSummaryResponse summary;

  TransactionSummarySuccess(this.summary);
}

class TransactionSummaryError extends TransactionSummaryState {
  final String message;

  TransactionSummaryError(this.message);
}
