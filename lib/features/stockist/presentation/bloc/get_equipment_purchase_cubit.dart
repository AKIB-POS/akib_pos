import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/equipment_purchase.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEquipmentPurchaseCubit extends Cubit<GetEquipmentPurchaseState> {
  final StockistRepository repository;

  GetEquipmentPurchaseCubit(this.repository) : super(GetEquipmentPurchaseInitial());

  Future<void> fetchEquipmentPurchases({required int branchId}) async {
    emit(GetEquipmentPurchaseLoading());

    final result = await repository.getEquipmentPurchases(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetEquipmentPurchaseError(failure.message));
        } else {
          emit(GetEquipmentPurchaseError('Failed to fetch equipment purchases.'));
        }
      },
      (equipmentPurchases) {
        emit(GetEquipmentPurchaseLoaded(equipmentPurchases));
      },
    );
  }
}

abstract class GetEquipmentPurchaseState {}

class GetEquipmentPurchaseInitial extends GetEquipmentPurchaseState {}

class GetEquipmentPurchaseLoading extends GetEquipmentPurchaseState {}

class GetEquipmentPurchaseLoaded extends GetEquipmentPurchaseState {
  final EquipmentPurchaseResponse equipmentPurchases;

  GetEquipmentPurchaseLoaded(this.equipmentPurchases);
}

class GetEquipmentPurchaseError extends GetEquipmentPurchaseState {
  final String message;

  GetEquipmentPurchaseError(this.message);
}
