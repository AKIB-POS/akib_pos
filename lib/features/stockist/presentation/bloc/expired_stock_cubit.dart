import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/expired_stock.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpiredStockCubit extends Cubit<ExpiredStockState> {
  final StockistRepository repository;

  ExpiredStockCubit(this.repository) : super(ExpiredStockInitial());

  Future<void> fetchExpiredStock({required int branchId}) async {
    emit(ExpiredStockLoading());

    final result = await repository.getExpiredStock(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(ExpiredStockError(failure.message));
        } else {
          emit(ExpiredStockError('Failed to fetch expired stock.'));
        }
      },
      (expiredStock) {
        emit(ExpiredStockLoaded(expiredStock));
      },
    );
  }
}

abstract class ExpiredStockState {}

class ExpiredStockInitial extends ExpiredStockState {}

class ExpiredStockLoading extends ExpiredStockState {}

class ExpiredStockLoaded extends ExpiredStockState {
  final ExpiredStockResponse expiredStock;

  ExpiredStockLoaded(this.expiredStock);
}

class ExpiredStockError extends ExpiredStockState {
  final String message;

  ExpiredStockError(this.message);
}
