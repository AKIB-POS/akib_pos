import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/add_equipment_type.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEquipmentTypeCubit extends Cubit<AddEquipmentTypeState> {
  final StockistRepository repository;

  AddEquipmentTypeCubit(this.repository) : super(AddEquipmentTypeInitial());

  Future<void> addEquipmentType(AddEquipmentTypeRequest request) async {
    emit(AddEquipmentTypeLoading());

    final result = await repository.addEquipmentType(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(AddEquipmentTypeError(failure.message));
        } else {
          emit(AddEquipmentTypeError('Failed to add equipment type.'));
        }
      },
      (response) {
        emit(AddEquipmentTypeSuccess(response.message));
      },
    );
  }
}
abstract class AddEquipmentTypeState {}

class AddEquipmentTypeInitial extends AddEquipmentTypeState {}

class AddEquipmentTypeLoading extends AddEquipmentTypeState {}

class AddEquipmentTypeSuccess extends AddEquipmentTypeState {
  final String message;

  AddEquipmentTypeSuccess(this.message);
}

class AddEquipmentTypeError extends AddEquipmentTypeState {
  final String message;

  AddEquipmentTypeError(this.message);
}
