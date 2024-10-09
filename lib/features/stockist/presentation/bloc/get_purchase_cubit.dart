import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/purchase.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPurchasesCubit extends Cubit<GetPurchasesState> {
  final StockistRepository repository;

  GetPurchasesCubit(this.repository) : super(GetPurchasesInitial());

  Future<void> fetchPurchases({required int branchId}) async {
    emit(GetPurchasesLoading());

    final result = await repository.getPurchases(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(GetPurchasesError(failure.message));
        } else {
          emit(GetPurchasesError('Failed to fetch purchases.'));
        }
      },
      (purchases) {
        emit(GetPurchasesLoaded(purchases));
      },
    );
  }
}
abstract class GetPurchasesState {}

class GetPurchasesInitial extends GetPurchasesState {}

class GetPurchasesLoading extends GetPurchasesState {}

class GetPurchasesLoaded extends GetPurchasesState {
  final PurchasesListResponse purchases;

  GetPurchasesLoaded(this.purchases);
}

class GetPurchasesError extends GetPurchasesState {
  final String message;

  GetPurchasesError(this.message);
}

