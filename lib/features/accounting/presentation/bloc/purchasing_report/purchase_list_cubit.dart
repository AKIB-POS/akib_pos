import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/purchasing_report/purchasing_item_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseListCubit extends Cubit<PurchaseListState> {
  final AccountingRepository repository;

  PurchaseListCubit({required this.repository}) : super(PurchaseListInitial());

  void fetchTotalPurchaseList({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    emit(PurchaseListLoading());

    final result = await repository.getTotalPurchaseList(
      branchId: branchId,
      companyId: companyId,
      date: date,
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(PurchaseListError(failure.message));
        } else {
          emit(PurchaseListError('Failed to fetch purchase list.'));
        }
      },
      (purchases) {
        emit(PurchaseListSuccess(purchases));
      },
    );
  }
}

abstract class PurchaseListState {}

class PurchaseListInitial extends PurchaseListState {}

class PurchaseListLoading extends PurchaseListState {}

class PurchaseListSuccess extends PurchaseListState {
  final List<PurchaseItemModel> purchases;

  PurchaseListSuccess(this.purchases);
}

class PurchaseListError extends PurchaseListState {
  final String message;

  PurchaseListError(this.message);
}
