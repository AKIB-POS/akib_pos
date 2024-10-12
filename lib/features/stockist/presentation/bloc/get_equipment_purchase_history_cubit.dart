import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:akib_pos/features/stockist/presentation/pages/equipment/equipment_purchase_history.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEquipmentPurchaseHistoryCubit extends Cubit<GetEquipmentPurchaseHistoryState> {
  final StockistRepository repository;

  GetEquipmentPurchaseHistoryCubit(this.repository) : super(GetEquipmentPurchaseHistoryInitial());

  Future<void> fetchPurchaseHistory({required int branchId, required int equipmentId}) async {
    emit(GetEquipmentPurchaseHistoryLoading());

    final result = await repository.getEquipmentPurchaseHistory(branchId, equipmentId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetEquipmentPurchaseHistoryError(failure.message));
        } else {
          emit(GetEquipmentPurchaseHistoryError('Failed to fetch purchase history.'));
        }
      },
      (purchaseHistory) {
        emit(GetEquipmentPurchaseHistoryLoaded(purchaseHistory));
      },
    );
  }
}
abstract class GetEquipmentPurchaseHistoryState {}

class GetEquipmentPurchaseHistoryInitial extends GetEquipmentPurchaseHistoryState {}

class GetEquipmentPurchaseHistoryLoading extends GetEquipmentPurchaseHistoryState {}

class GetEquipmentPurchaseHistoryLoaded extends GetEquipmentPurchaseHistoryState {
  final EquipmentPurchaseHistoryResponse purchaseHistoryResponse;

  GetEquipmentPurchaseHistoryLoaded(this.purchaseHistoryResponse);
}

class GetEquipmentPurchaseHistoryError extends GetEquipmentPurchaseHistoryState {
  final String message;

  GetEquipmentPurchaseHistoryError(this.message);
}
