import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/asset_depreciation_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetDepreciationCubit extends Cubit<AssetDepreciationState> {
  final AccountingRepository repository;

  AssetDepreciationCubit({required this.repository})
      : super(AssetsDepreciationInitial());

  Future<void> fetchAssetsDepreciation({
    required int branchId,
    required int companyId,
  }) async {
    try {
      emit(AssetsDepreciationLoading());
      final result = await repository.getAssetsDepreciation(
        branchId: branchId,
        companyId: companyId,
      );
      result.fold(
        (failure) => emit(AssetsDepreciationError(_mapFailureToMessage(failure))),
        (depreciations) => emit(AssetsDepreciationLoaded(depreciations)),
      );
    } catch (e) {
      emit(AssetsDepreciationError(e.toString()));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Failure';
    } else if (failure is GeneralFailure) {
      return failure.message;
    } else {
      return 'Unexpected Error';
    }
  }
}


abstract class AssetDepreciationState {}

class AssetsDepreciationInitial extends AssetDepreciationState {}

class AssetsDepreciationLoading extends AssetDepreciationState {}

class AssetsDepreciationLoaded extends AssetDepreciationState {
  final List<AssetsDepreciationModel> depreciations;

  AssetsDepreciationLoaded(this.depreciations);
}

class AssetsDepreciationError extends AssetDepreciationState {
  final String message;

  AssetsDepreciationError(this.message);
}
