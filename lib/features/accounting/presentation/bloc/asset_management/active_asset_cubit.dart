import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/active_asset_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveAssetState {}

class ActiveAssetInitial extends ActiveAssetState {}

class ActiveAssetLoading extends ActiveAssetState {}

class ActiveAssetLoaded extends ActiveAssetState {
  final List<ActiveAssetModel> activeAssets;

  ActiveAssetLoaded(this.activeAssets);
}

class ActiveAssetError extends ActiveAssetState {
  final String message;

  ActiveAssetError(this.message);
}

class ActiveAssetCubit extends Cubit<ActiveAssetState> {
  final AccountingRepository repository;

  ActiveAssetCubit(this.repository) : super(ActiveAssetInitial());

  Future<void> fetchActiveAssets(int branchId, int companyId) async {
    emit(ActiveAssetLoading());
    final result = await repository.getActiveAssets(
      branchId: branchId,
      companyId: companyId,
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(ActiveAssetError(failure.message));
        } else {
          emit(ActiveAssetError('Failed to fetch active assets.'));
        }
      },
      (activeAssets) {
        emit(ActiveAssetLoaded(activeAssets));
      },
    );
  }
}
