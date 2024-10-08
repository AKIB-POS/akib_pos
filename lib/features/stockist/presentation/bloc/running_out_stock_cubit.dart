import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/stockist/data/models/running_out_stock.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RunningOutStockCubit extends Cubit<RunningOutStockState> {
  final StockistRepository repository;

  RunningOutStockCubit(this.repository) : super(RunningOutStockInitial());

  Future<void> fetchRunningOutStock({required int branchId}) async {
    emit(RunningOutStockLoading());

    final result = await repository.getRunningOutStock(branchId);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(RunningOutStockError(failure.message));
        } else {
          emit(RunningOutStockError('Failed to fetch running out stock.'));
        }
      },
      (runningOutStock) {
        emit(RunningOutStockLoaded(runningOutStock));
      },
    );
  }
}

abstract class RunningOutStockState {}

class RunningOutStockInitial extends RunningOutStockState {}

class RunningOutStockLoading extends RunningOutStockState {}

class RunningOutStockLoaded extends RunningOutStockState {
  final RunningOutStockResponse runningOutStock;

  RunningOutStockLoaded(this.runningOutStock);
}

class RunningOutStockError extends RunningOutStockState {
  final String message;

  RunningOutStockError(this.message);
}
