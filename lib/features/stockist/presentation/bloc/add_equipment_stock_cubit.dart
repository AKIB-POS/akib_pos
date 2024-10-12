import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/add_equipment_stock.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEquipmentStockCubit extends Cubit<AddEquipmentStockState> {
  final StockistRepository repository;

  AddEquipmentStockCubit(this.repository) : super(AddEquipmentStockInitial());

  Future<void> addEquipmentStock(AddEquipmentStockRequest request) async {
    emit(AddEquipmentStockLoading());
    final result = await repository.addEquipmentStock(request);

    
    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(AddEquipmentStockError(failure.message));
        } else {
          emit(AddEquipmentStockError('Failed to add equipment type.'));
        }
      },
      (response) {
        emit(AddEquipmentStockSuccess(response.message));
      },
    );
  }
}

abstract class AddEquipmentStockState {}

class AddEquipmentStockInitial extends AddEquipmentStockState {}

class AddEquipmentStockLoading extends AddEquipmentStockState {}

class AddEquipmentStockSuccess extends AddEquipmentStockState {
  final String message;
  AddEquipmentStockSuccess(this.message);
}

class AddEquipmentStockError extends AddEquipmentStockState {
  final String message;
  AddEquipmentStockError(this.message);
}
