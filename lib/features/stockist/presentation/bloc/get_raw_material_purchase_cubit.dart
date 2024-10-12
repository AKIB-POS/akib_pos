import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material/raw_material_purchase.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetRawMaterialPurchaseCubit extends Cubit<GetRawmaterialPurchasesState> {
  final StockistRepository repository;

  GetRawMaterialPurchaseCubit(this.repository) : super(GetRawMaterialPurchasesInitial());

  Future<void> fetchPurchases({required int branchId}) async {
    emit(GetRawMaterialPurchasesLoading());

    final result = await repository.getRawMaterialPurcases(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetRawMaterialPurchasesError(failure.message));
        } else {
          emit(GetRawMaterialPurchasesError('Failed to fetch purchases.'));
        }
      },
      (purchases) {
        emit(GetRawMaterialPurchasesLoaded(purchases));
      },
    );
  }
}
abstract class GetRawmaterialPurchasesState {}

class GetRawMaterialPurchasesInitial extends GetRawmaterialPurchasesState {}

class GetRawMaterialPurchasesLoading extends GetRawmaterialPurchasesState {}

class GetRawMaterialPurchasesLoaded extends GetRawmaterialPurchasesState {
  final RawMaterialPurchasesResponse purchases;

  GetRawMaterialPurchasesLoaded(this.purchases);
}

class GetRawMaterialPurchasesError extends GetRawmaterialPurchasesState {
  final String message;

  GetRawMaterialPurchasesError(this.message);
}

