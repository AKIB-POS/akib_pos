import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/dashboard/data/models/dashboard_accounting_summary.dart';
import 'package:akib_pos/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetDashboardAccountingSummaryCubit extends Cubit<GetDashboardAccountingSummaryState> {
  final DashboardRepository repository;

  GetDashboardAccountingSummaryCubit(this.repository) : super(GetDashboardAccountingSummaryInitial());

  Future<void> fetchAccountingSummary({required int branchId}) async {
    emit(GetDashboardAccountingSummaryLoading());

    final result = await repository.getAccountingSummary(branchId);

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(GetDashboardAccountingSummaryError('No Internet connection'));
        } else if (failure is GeneralFailure) {
          emit(GetDashboardAccountingSummaryError(failure.message));
        } else {
          emit(GetDashboardAccountingSummaryError('Failed to fetch accounting summary.'));
        }
      },
      (summaryResponse) {
        emit(GetDashboardAccountingSummaryLoaded(summaryResponse));
      },
    );
  }
}

abstract class GetDashboardAccountingSummaryState {}

class GetDashboardAccountingSummaryInitial extends GetDashboardAccountingSummaryState {}

class GetDashboardAccountingSummaryLoading extends GetDashboardAccountingSummaryState {}

class GetDashboardAccountingSummaryLoaded extends GetDashboardAccountingSummaryState {
  final DashboardAccountingSummaryResponse accountingSummary;

  GetDashboardAccountingSummaryLoaded(this.accountingSummary);
}

class GetDashboardAccountingSummaryError extends GetDashboardAccountingSummaryState {
  final String message;

  GetDashboardAccountingSummaryError(this.message);
}
