import 'package:akib_pos/features/accounting/data/models/asset_management/pending_asset_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

class PendingAssetCubit extends Cubit<PendingAssetState> {
  final AccountingRepository repository;

  PendingAssetCubit(this.repository) : super(PendingAssetInitial());

  Future<void> fetchPendingAssets({
    required int branchId,
    required int companyId,
  }) async {
    emit(PendingAssetLoading());

    final result = await repository.getPendingAssets(
      branchId: branchId,
      companyId: companyId,
    );

    result.fold(
      (failure) => emit(PendingAssetError('Failed to load pending assets')),
      (pendingAssets) => emit(PendingAssetLoaded(pendingAssets)),
    );
  }
}

abstract class PendingAssetState {}

class PendingAssetInitial extends PendingAssetState {}

class PendingAssetLoading extends PendingAssetState {}

class PendingAssetLoaded extends PendingAssetState {
  final List<PendingAssetModel> pendingAssets;

  PendingAssetLoaded(this.pendingAssets);
}

class PendingAssetError extends PendingAssetState {
  final String message;

  PendingAssetError(this.message);
}

