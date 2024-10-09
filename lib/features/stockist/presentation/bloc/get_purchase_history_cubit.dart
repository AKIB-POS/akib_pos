import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/purchase_history.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPurchaseHistoryCubit extends Cubit<GetPurchaseHistoryState> {
  final StockistRepository repository;

  GetPurchaseHistoryCubit(this.repository) : super(GetPurchaseHistoryInitial());

  Future<void> fetchPurchaseHistory({required int branchId, required int materialId}) async {
    emit(GetPurchaseHistoryLoading());

    final result = await repository.getPurchaseHistory(branchId, materialId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetPurchaseHistoryError(failure.message));
        } else {
          emit(GetPurchaseHistoryError('Failed to fetch purchase history.'));
        }
      },
      (purchaseHistory) {
        emit(GetPurchaseHistoryLoaded(purchaseHistory));
      },
    );
  }
}

abstract class GetPurchaseHistoryState {}

class GetPurchaseHistoryInitial extends GetPurchaseHistoryState {}

class GetPurchaseHistoryLoading extends GetPurchaseHistoryState {}

class GetPurchaseHistoryLoaded extends GetPurchaseHistoryState {
  final PurchaseHistoryResponse purchaseHistoryResponse;

  GetPurchaseHistoryLoaded(this.purchaseHistoryResponse);
}

class GetPurchaseHistoryError extends GetPurchaseHistoryState {
  final String message;

  GetPurchaseHistoryError(this.message);
}
