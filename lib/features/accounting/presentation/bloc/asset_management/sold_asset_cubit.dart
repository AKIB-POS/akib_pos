// State untuk SoldAssetCubit
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/sold_asset_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SoldAssetState {}

class SoldAssetInitial extends SoldAssetState {}

class SoldAssetLoading extends SoldAssetState {}

class SoldAssetLoaded extends SoldAssetState {
  final List<SoldAssetModel> soldAssets;

  SoldAssetLoaded(this.soldAssets);
}

class SoldAssetError extends SoldAssetState {
  final String message;

  SoldAssetError(this.message);
}

// Cubit untuk SoldAsset
class SoldAssetCubit extends Cubit<SoldAssetState> {
  final AccountingRepository repository;

  SoldAssetCubit({required this.repository}) : super(SoldAssetInitial());

  Future<void> fetchSoldAssets({required int branchId, required int companyId}) async {
  
      emit(SoldAssetLoading());
      final result = await repository.getSoldAssets(
        branchId: branchId,
        companyId: companyId,
      );

      result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(SoldAssetError(failure.message));
        } else {
          emit(SoldAssetError('Failed to fetch active assets.'));
        }
      },
      (activeAssets) {
        emit(SoldAssetLoaded(activeAssets));
      },
    );
  }
}
