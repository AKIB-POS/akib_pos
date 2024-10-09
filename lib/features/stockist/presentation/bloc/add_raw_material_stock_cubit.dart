import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/add_raw_material_stock.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRawMaterialStockCubit extends Cubit<AddRawMaterialStockState> {
  final StockistRepository repository;

  AddRawMaterialStockCubit(this.repository) : super(AddRawMaterialStockInitial());

  Future<void> addStock(AddRawMaterialStockRequest request) async {
    emit(AddRawMaterialStockLoading());

    final result = await repository.addRawMaterialStock(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(AddRawMaterialStockError(failure.message));
        } else {
          emit(AddRawMaterialStockError('Failed to add stock.'));
        }
      },
      (addStockResponse) {
        emit(AddRawMaterialStockSuccess(addStockResponse.message));
      },
    );
  }
}

abstract class AddRawMaterialStockState {}

class AddRawMaterialStockInitial extends AddRawMaterialStockState {}

class AddRawMaterialStockLoading extends AddRawMaterialStockState {}

class AddRawMaterialStockSuccess extends AddRawMaterialStockState {
  final String message;

  AddRawMaterialStockSuccess(this.message);
}

class AddRawMaterialStockError extends AddRawMaterialStockState {
  final String message;

  AddRawMaterialStockError(this.message);
}
