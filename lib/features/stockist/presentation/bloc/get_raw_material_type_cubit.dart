import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/stock/raw_material/raw_material.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetRawMaterialTypeCubit extends Cubit<GetRawMaterialTypeState> {
  final StockistRepository repository;

  GetRawMaterialTypeCubit(this.repository) : super(GetRawMaterialTypeInitial());

  Future<void> fetchRawMaterialTypes({required int branchId}) async {
    emit(GetRawMaterialTypeLoading());

    final result = await repository.getRawMaterialTypes(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetRawMaterialTypeError(failure.message));
        } else {
          emit(GetRawMaterialTypeError('Failed to fetch raw material types.'));
        }
      },
      (rawMaterialTypes) {
        emit(GetRawMaterialTypeLoaded(rawMaterialTypes));
      },
    );
  }
}

abstract class GetRawMaterialTypeState {}

class GetRawMaterialTypeInitial extends GetRawMaterialTypeState {}

class GetRawMaterialTypeLoading extends GetRawMaterialTypeState {}

class GetRawMaterialTypeLoaded extends GetRawMaterialTypeState {
  final RawMaterialTypeResponse rawMaterials;

  GetRawMaterialTypeLoaded(this.rawMaterials);
}

class GetRawMaterialTypeError extends GetRawMaterialTypeState {
  final String message;

  GetRawMaterialTypeError(this.message);
}
