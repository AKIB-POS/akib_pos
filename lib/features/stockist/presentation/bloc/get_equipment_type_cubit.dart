import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/equipment.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEquipmentTypeCubit extends Cubit<GetEquipmentTypeState> {
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
abstract class GetEquipmentTypeState {}

class GetEquipmentListInitial extends GetEquipmentTypeState {}

class GetEquipmentListLoading extends GetEquipmentTypeState {}

class GetEquipmentListLoaded extends GetEquipmentTypeState {
  final List<Equipment> equipmentList;

  GetEquipmentListLoaded(this.equipmentList);
}

class GetEquipmentListError extends GetEquipmentTypeState {
  final String message;

  GetEquipmentListError(this.message);
}
