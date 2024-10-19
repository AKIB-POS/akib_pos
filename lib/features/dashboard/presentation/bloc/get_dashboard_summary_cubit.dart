import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/dashboard/data/models/dashboard_summary_response.dart';
import 'package:akib_pos/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetDashboardSummaryHrdCubit extends Cubit<GetDashboardSummaryHrdState> {
  final DashboardRepository repository;

  GetDashboardSummaryHrdCubit(this.repository) : super(GetDashboardSummaryHrdInitial());

  Future<void> fetchDashboardHrdSummary({required int branchId}) async {
    emit(GetDashboardSummaryHrdLoading());

    final result = await repository.getDashboardHrdSummary(branchId);

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(GetDashboardSummaryHrdError('No Internet connection'));
        } else if (failure is GeneralFailure) {
          emit(GetDashboardSummaryHrdError(failure.message));
        } else {
          emit(GetDashboardSummaryHrdError('Failed to fetch HRD summary.'));
        }
      },
      (summaryResponse) {
        emit(GetDashboardSummaryHrdLoaded(summaryResponse));
      },
    );
  }
}
abstract class GetDashboardSummaryHrdState {}

class GetDashboardSummaryHrdInitial extends GetDashboardSummaryHrdState {}

class GetDashboardSummaryHrdLoading extends GetDashboardSummaryHrdState {}

class GetDashboardSummaryHrdLoaded extends GetDashboardSummaryHrdState {
  final DashboardSummaryHrdResponse hrdSummary;

  GetDashboardSummaryHrdLoaded(this.hrdSummary);
}

class GetDashboardSummaryHrdError extends GetDashboardSummaryHrdState {
  final String message;

  GetDashboardSummaryHrdError(this.message);
}
