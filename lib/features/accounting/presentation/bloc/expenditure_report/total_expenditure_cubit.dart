import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/expenditure_report/total_expenditure.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalExpenditureCubit extends Cubit<TotalExpenditureState> {
  final AccountingRepository repository;

  TotalExpenditureCubit({required this.repository}) : super(TotalExpenditureInitial());

  void fetchTotalExpenditure({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    emit(TotalExpenditureLoading());

    final result = await repository.getTotalExpenditure(
      branchId: branchId,
      companyId: companyId,
      date: date,
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(TotalExpenditureError(failure.message));
        } else {
          emit(TotalExpenditureError('Failed to fetch total expenditure.'));
        }
      },
      (totalExpenditure) {
        emit(TotalExpenditureSuccess(totalExpenditure));
      },
    );
  }
}

abstract class TotalExpenditureState {}

class TotalExpenditureInitial extends TotalExpenditureState {}

class TotalExpenditureLoading extends TotalExpenditureState {}

class TotalExpenditureSuccess extends TotalExpenditureState {
  final TotalExpenditureModel totalExpenditure;

  TotalExpenditureSuccess(this.totalExpenditure);
}

class TotalExpenditureError extends TotalExpenditureState {
  final String message;

  TotalExpenditureError(this.message);
}
