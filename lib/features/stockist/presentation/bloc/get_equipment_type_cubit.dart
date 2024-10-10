import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/equipment.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEquipmentTypeCubit extends Cubit<GetEquipmentListState> {
  final StockistRepository repository;

  GetEquipmentTypeCubit(this.repository) : super(GetEquipmentListInitial());

  Future<void> fetchEquipmentList({required int branchId, required String category}) async {
    emit(GetEquipmentListLoading());

    final result = await repository.getEquipmentType(branchId, category);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetEquipmentListError(failure.message));
        } else {
          emit(GetEquipmentListError('Failed to fetch equipment list.'));
        }
      },
      (equipmentListResponse) {
        emit(GetEquipmentListLoaded(equipmentListResponse.equipmentList));
      },
    );
  }
}
abstract class GetEquipmentListState {}

class GetEquipmentListInitial extends GetEquipmentListState {}

class GetEquipmentListLoading extends GetEquipmentListState {}

class GetEquipmentListLoaded extends GetEquipmentListState {
  final List<Equipment> equipmentList;

  GetEquipmentListLoaded(this.equipmentList);
}

class GetEquipmentListError extends GetEquipmentListState {
  final String message;

  GetEquipmentListError(this.message);
}
