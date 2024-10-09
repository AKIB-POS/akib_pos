import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/warehouse.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetWarehousesCubit extends Cubit<GetWarehousesState> {
  final StockistRepository repository;

  GetWarehousesCubit(this.repository) : super(GetWarehousesInitial());

  Future<void> fetchWarehouses({required int branchId}) async {
    emit(GetWarehousesLoading());

    final result = await repository.getWarehouses(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetWarehousesError(failure.message));
        } else {
          emit(GetWarehousesError('Failed to fetch warehouses.'));
        }
      },
      (warehousesResponse) {
        emit(GetWarehousesLoaded(warehousesResponse));
      },
    );
  }
}

abstract class GetWarehousesState {}

class GetWarehousesInitial extends GetWarehousesState {}

class GetWarehousesLoading extends GetWarehousesState {}

class GetWarehousesLoaded extends GetWarehousesState {
  final GetWarehousesResponse warehousesResponse;

  GetWarehousesLoaded(this.warehousesResponse);
}

class GetWarehousesError extends GetWarehousesState {
  final String message;

  GetWarehousesError(this.message);
}
