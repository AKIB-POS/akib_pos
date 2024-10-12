import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/dashboard/data/models/top_products.dart';
import 'package:akib_pos/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetDashboardTopProductsCubit extends Cubit<GetDashboardTopProductsState> {
  final DashboardRepository repository;

  GetDashboardTopProductsCubit(this.repository) : super(GetDashboardTopProductsInitial());

  Future<void> fetchTopProducts({required int branchId}) async {
    emit(GetDashboardTopProductsLoading());

    final result = await repository.getTopProducts(branchId);

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(GetDashboardTopProductsError('No Internet connection'));
        } else if (failure is GeneralFailure) {
          emit(GetDashboardTopProductsError(failure.message));
        } else {
          emit(GetDashboardTopProductsError('Failed to fetch top products.'));
        }
      },
      (topProductsResponse) {
        emit(GetDashboardTopProductsLoaded(topProductsResponse));
      },
    );
  }
}

abstract class GetDashboardTopProductsState {}

class GetDashboardTopProductsInitial extends GetDashboardTopProductsState {}

class GetDashboardTopProductsLoading extends GetDashboardTopProductsState {}

class GetDashboardTopProductsLoaded extends GetDashboardTopProductsState {
  final TopProductsResponse topProductsResponse;

  GetDashboardTopProductsLoaded(this.topProductsResponse);
}

class GetDashboardTopProductsError extends GetDashboardTopProductsState {
  final String message;

  GetDashboardTopProductsError(this.message);
}
