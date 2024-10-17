import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/dashboard/data/models/dashbord_summary_stock.dart';
import 'package:akib_pos/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetDashboardSummaryStockCubit extends Cubit<GetDashboardSummaryStockState> {
  final DashboardRepository repository;

  GetDashboardSummaryStockCubit(this.repository) : super(GetDashboardSummaryStockInitial());

  Future<void> fetchDashboardStockSummary({required int branchId}) async {
    emit(GetDashboardSummaryStockLoading());

    final result = await repository.getStockSummary(branchId);

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(GetDashboardSummaryStockError('No Internet connection'));
        } else if (failure is GeneralFailure) {
          emit(GetDashboardSummaryStockError(failure.message));
        } else {
          emit(GetDashboardSummaryStockError('Failed to fetch stock summary.'));
        }
      },
      (stockSummaryResponse) {
        emit(GetDashboardSummaryStockLoaded(stockSummaryResponse.stockSummary));
      },
    );
  }
}

abstract class GetDashboardSummaryStockState {}

class GetDashboardSummaryStockInitial extends GetDashboardSummaryStockState {}

class GetDashboardSummaryStockLoading extends GetDashboardSummaryStockState {}

class GetDashboardSummaryStockLoaded extends GetDashboardSummaryStockState {
  final DashboardSummaryStock stockSummary;

  GetDashboardSummaryStockLoaded(this.stockSummary);
}

class GetDashboardSummaryStockError extends GetDashboardSummaryStockState {
  final String message;

  GetDashboardSummaryStockError(this.message);
}
