import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_summary.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StockistSummaryCubit extends Cubit<StockistSummaryState> {
  final StockistRepository repository;

  StockistSummaryCubit(this.repository) : super(StockistSummaryInitial());

  Future<void>  fetchStockistSummary({required int branchId}) async {
    emit(StockistSummaryLoading());

    final result = await repository.getStockistSummary(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(StockistSummaryError(failure.message));
        } else {
          emit(StockistSummaryError('Failed to fetch stockist summary.'));
        }
      },
      (stockistSummary) {
        emit(StockistSummaryLoaded(stockistSummary));
      },
    );
  }
}

abstract class StockistSummaryState {}

class StockistSummaryInitial extends StockistSummaryState {}

class StockistSummaryLoading extends StockistSummaryState {}

class StockistSummaryLoaded extends StockistSummaryState {
  final StockistSummaryResponse stockistSummary;

  StockistSummaryLoaded(this.stockistSummary);
}

class StockistSummaryError extends StockistSummaryState {
  final String message;

  StockistSummaryError(this.message);
}

