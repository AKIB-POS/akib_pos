import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/dashboard/data/models/sales_chart.dart';
import 'package:akib_pos/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetSalesChartCubit extends Cubit<GetSalesChartState> {
  final DashboardRepository repository;

  GetSalesChartCubit(this.repository) : super(GetSalesChartInitial());

  Future<void> fetchSalesChart({required int branchId}) async {
    emit(GetSalesChartLoading());

    final result = await repository.getSalesChart(branchId);

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(GetSalesChartError('No Internet connection'));
        } else if (failure is GeneralFailure) {
          emit(GetSalesChartError(failure.message));
        } else {
          emit(GetSalesChartError('Failed to fetch sales chart data.'));
        }
      },
      (salesChartResponse) {
        emit(GetSalesChartLoaded(salesChartResponse));
      },
    );
  }
}

abstract class GetSalesChartState {}

class GetSalesChartInitial extends GetSalesChartState {}

class GetSalesChartLoading extends GetSalesChartState {}

class GetSalesChartLoaded extends GetSalesChartState {
  final SalesChartResponse salesChartResponse;

  GetSalesChartLoaded(this.salesChartResponse);
}

class GetSalesChartError extends GetSalesChartState {
  final String message;

  GetSalesChartError(this.message);
}
