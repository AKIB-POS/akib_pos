import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/dashboard/data/models/purchase_chart.dart';
import 'package:akib_pos/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPurchaseChartCubit extends Cubit<GetPurchaseChartState> {
  final DashboardRepository repository;

  GetPurchaseChartCubit(this.repository) : super(GetPurchaseChartInitial());

  Future<void> fetchPurchaseChart({required int branchId}) async {
    emit(GetPurchaseChartLoading());

    final result = await repository.getPurchaseChart(branchId);

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(GetPurchaseChartError('No Internet connection'));
        } else if (failure is GeneralFailure) {
          emit(GetPurchaseChartError(failure.message));
        } else {
          emit(GetPurchaseChartError('Failed to fetch purchase chart data.'));
        }
      },
      (purchaseChartResponse) {
        emit(GetPurchaseChartLoaded(purchaseChartResponse));
      },
    );
  }
}

abstract class GetPurchaseChartState {}

class GetPurchaseChartInitial extends GetPurchaseChartState {}

class GetPurchaseChartLoading extends GetPurchaseChartState {}

class GetPurchaseChartLoaded extends GetPurchaseChartState {
  final PurchaseChartResponse purchaseChart;

  GetPurchaseChartLoaded(this.purchaseChart);
}

class GetPurchaseChartError extends GetPurchaseChartState {
  final String message;

  GetPurchaseChartError(this.message);
}
