import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/sales_report/sales_report_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesReportCubit extends Cubit<SalesReportState> {
  final AccountingRepository repository;

  SalesReportCubit({required this.repository}) : super(SalesReportInitial());

  void fetchSalesReport({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    emit(SalesReportLoading());

    final result = await repository.getSalesReportSummary(
      branchId: branchId,
      companyId: companyId,
      date: date,
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(SalesReportError(failure.message));
        } else {
          emit(SalesReportError('Failed to fetch sales report.'));
        }
      },
      (report) {
        emit(SalesReportSuccess(report));
      },
    );
  }
}

abstract class SalesReportState {}

class SalesReportInitial extends SalesReportState {}

class SalesReportLoading extends SalesReportState {}

class SalesReportSuccess extends SalesReportState {
  final SalesReportModel report;

  SalesReportSuccess(this.report);
}

class SalesReportError extends SalesReportState {
  final String message;

  SalesReportError(this.message);
}
