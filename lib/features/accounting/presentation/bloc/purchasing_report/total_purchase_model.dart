import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/purchasing_report/total_purchase_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalPurchaseCubit extends Cubit<TotalPurchaseState> {
  final AccountingRepository repository;

  TotalPurchaseCubit({required this.repository}) : super(TotalPurchaseInitial());

  void fetchTotalPurchase({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    emit(TotalPurchaseLoading());

    final result = await repository.getTotalPurchase(
      branchId: branchId,
      companyId: companyId,
      date: date,
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(TotalPurchaseError(failure.message));
        } else {
          emit(TotalPurchaseError('Failed to fetch total purchase.'));
        }
      },
      (totalPurchase) {
        emit(TotalPurchaseSuccess(totalPurchase));
      },
    );
  }
}

abstract class TotalPurchaseState {}

class TotalPurchaseInitial extends TotalPurchaseState {}

class TotalPurchaseLoading extends TotalPurchaseState {}

class TotalPurchaseSuccess extends TotalPurchaseState {
  final TotalPurchaseModel totalPurchase;

  TotalPurchaseSuccess(this.totalPurchase);
}

class TotalPurchaseError extends TotalPurchaseState {
  final String message;

  TotalPurchaseError(this.message);
}
