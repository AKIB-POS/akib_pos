import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/financial_balance_report/financial_balance_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinancialBalanceCubit extends Cubit<FinancialBalanceState> {
  final AccountingRepository repository;

  FinancialBalanceCubit({required this.repository}) : super(FinancialBalanceInitial());

  Future<void> fetchFinancialBalance(int branchId, int companyId, String date) async {
    try {
      emit(FinancialBalanceLoading());
      final result = await repository.getFinancialBalance(
        branchId: branchId,
        companyId: companyId,
        date: date,
      );
      result.fold(
        (failure) => emit(FinancialBalanceError(_mapFailureToMessage(failure))),
        (financialBalance) => emit(FinancialBalanceLoaded(financialBalance)),
      );
    } catch (e) {
      emit(FinancialBalanceError(e.toString()));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Failure';
    } else {
      return 'Unexpected Error';
    }
  }
}




abstract class FinancialBalanceState {}

class FinancialBalanceInitial extends FinancialBalanceState {}

class FinancialBalanceLoading extends FinancialBalanceState {}

class FinancialBalanceLoaded extends FinancialBalanceState {
  final FinancialBalanceModel financialBalance;

  FinancialBalanceLoaded(this.financialBalance);
}

class FinancialBalanceError extends FinancialBalanceState {
  final String message;

  FinancialBalanceError(this.message);
}
