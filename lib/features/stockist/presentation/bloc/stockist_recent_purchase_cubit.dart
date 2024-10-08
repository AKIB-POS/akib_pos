import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_recent_purchase.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StockistRecentPurchasesCubit extends Cubit<StockistRecentPurchasesState> {
  final StockistRepository repository;

  StockistRecentPurchasesCubit(this.repository) : super(StockistRecentPurchasesInitial());

  Future<void> fetchStockistRecentPurchases({required int branchId}) async {
    emit(StockistRecentPurchasesLoading());

    final result = await repository.getStockistRecentPurchases(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(StockistRecentPurchasesError(failure.message));
        } else {
          emit(StockistRecentPurchasesError('Failed to fetch recent purchases.'));
        }
      },
      (recentPurchases) {
        emit(StockistRecentPurchasesLoaded(recentPurchases));
      },
    );
  }
}
abstract class StockistRecentPurchasesState {}

class StockistRecentPurchasesInitial extends StockistRecentPurchasesState {}

class StockistRecentPurchasesLoading extends StockistRecentPurchasesState {}

class StockistRecentPurchasesLoaded extends StockistRecentPurchasesState {
  final StockistRecentPurchasesResponse recentPurchases;

  StockistRecentPurchasesLoaded(this.recentPurchases);
}

class StockistRecentPurchasesError extends StockistRecentPurchasesState {
  final String message;

  StockistRecentPurchasesError(this.message);
}
