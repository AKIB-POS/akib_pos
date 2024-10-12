import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/purchase_history.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetRawMaterialPurchaseHistoryCubit extends Cubit<GetRawMaterialPurchaseHistoryState> {
  final StockistRepository repository;

  GetRawMaterialPurchaseHistoryCubit(this.repository) : super(GetRawMaterialPurchaseHistoryInitial());

  Future<void> fetchRawMaterialPurchaseHistory({required int branchId, required int materialId}) async {
    emit(GetRawMaterialPurchaseHistoryLoading());

    final result = await repository.getRawMaterialPurchaseHistory(branchId, materialId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetRawMaterialPurchaseHistoryError(failure.message));
        } else {
          emit(GetRawMaterialPurchaseHistoryError('Failed to fetch purchase history.'));
        }
      },
      (RawMaterialpurchaseHistory) {
        emit(GetRawMaterialPurchaseHistoryLoaded(RawMaterialpurchaseHistory));
      },
    );
  }
}

abstract class GetRawMaterialPurchaseHistoryState {}

class GetRawMaterialPurchaseHistoryInitial extends GetRawMaterialPurchaseHistoryState {}

class GetRawMaterialPurchaseHistoryLoading extends GetRawMaterialPurchaseHistoryState {}

class GetRawMaterialPurchaseHistoryLoaded extends GetRawMaterialPurchaseHistoryState {
  final RawMaterialPurchaseHistoryResponse RawMaterialpurchaseHistoryResponse;

  GetRawMaterialPurchaseHistoryLoaded(this.RawMaterialpurchaseHistoryResponse);
}

class GetRawMaterialPurchaseHistoryError extends GetRawMaterialPurchaseHistoryState {
  final String message;

  GetRawMaterialPurchaseHistoryError(this.message);
}
