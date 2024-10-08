import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/add_raw_material.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRawMaterialCubit extends Cubit<AddRawMaterialState> {
  final StockistRepository repository;

  AddRawMaterialCubit(this.repository) : super(AddRawMaterialInitial());

  Future<void> addRawMaterial(AddRawMaterialRequest request) async {
    emit(AddRawMaterialLoading());

    final result = await repository.addRawMaterial(request);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(AddRawMaterialError(failure.message));
        } else {
          emit(AddRawMaterialError('Failed to add raw material.'));
        }
      },
      (response) {
        emit(AddRawMaterialSuccess(response));
      },
    );
  }
}
abstract class AddRawMaterialState {}

class AddRawMaterialInitial extends AddRawMaterialState {}

class AddRawMaterialLoading extends AddRawMaterialState {}

class AddRawMaterialSuccess extends AddRawMaterialState {
  final AddRawMaterialResponse response;

  AddRawMaterialSuccess(this.response);
}

class AddRawMaterialError extends AddRawMaterialState {
  final String message;

  AddRawMaterialError(this.message);
}
