import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetRawMaterialCubit extends Cubit<GetRawMaterialState> {
  final StockistRepository repository;

  GetRawMaterialCubit(this.repository) : super(GetRawMaterialInitial());

  Future<void> fetchRawMaterials({required int branchId}) async {
    emit(GetRawMaterialLoading());

    final result = await repository.getRawMaterials(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetRawMaterialError(failure.message));
        } else {
          emit(GetRawMaterialError('Failed to fetch raw materials.'));
        }
      },
      (rawMaterials) {
        emit(GetRawMaterialLoaded(rawMaterials));
      },
    );
  }
}

abstract class GetRawMaterialState {}

class GetRawMaterialInitial extends GetRawMaterialState {}

class GetRawMaterialLoading extends GetRawMaterialState {}

class GetRawMaterialLoaded extends GetRawMaterialState {
  final RawMaterialListResponse rawMaterials;

  GetRawMaterialLoaded(this.rawMaterials);
}

class GetRawMaterialError extends GetRawMaterialState {
  final String message;

  GetRawMaterialError(this.message);
}
