import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material/material_detail.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMaterialDetailCubit extends Cubit<GetMaterialDetailState> {
  final StockistRepository repository;

  GetMaterialDetailCubit(this.repository) : super(GetMaterialDetailInitial());

  Future<void> fetchMaterialDetail({required int branchId, required int materialId}) async {
    emit(GetMaterialDetailLoading());

    final result = await repository.getMaterialDetail(branchId, materialId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetMaterialDetailError(failure.message));
        } else {
          emit(GetMaterialDetailError('Failed to fetch material detail.'));
        }
      },
      (materialDetail) {
        emit(GetMaterialDetailLoaded(materialDetail));
      },
    );
  }
}

abstract class GetMaterialDetailState {}

class GetMaterialDetailInitial extends GetMaterialDetailState {}

class GetMaterialDetailLoading extends GetMaterialDetailState {}

class GetMaterialDetailLoaded extends GetMaterialDetailState {
  final MaterialDetailResponse materialDetail;

  GetMaterialDetailLoaded(this.materialDetail);
}

class GetMaterialDetailError extends GetMaterialDetailState {
  final String message;

  GetMaterialDetailError(this.message);
}
