import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/cash_flow_report/cash_flow_report_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CashFlowReportCubit extends Cubit<CashFlowReportState> {
  final AccountingRepository repository;

  CashFlowReportCubit({required this.repository}) : super(CashFlowReportInitial());

  Future<void> fetchCashFlowReport(int branchId, int companyId, String date) async {
    emit(CashFlowReportLoading());

    final result = await repository.getCashFlowReport(branchId, companyId, date);

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(CashFlowReportError(failure.message));
        } else {
          emit(CashFlowReportError('Gagal memuat laporan arus kas.'));
        }
      },
      (report) {
        emit(CashFlowReportSuccess(report));
      },
    );
  }
}
abstract class CashFlowReportState {}

class CashFlowReportInitial extends CashFlowReportState {}

class CashFlowReportLoading extends CashFlowReportState {}

class CashFlowReportSuccess extends CashFlowReportState {
  final CashFlowReportModel report;

  CashFlowReportSuccess(this.report);
}

class CashFlowReportError extends CashFlowReportState {
  final String message;

  CashFlowReportError(this.message);
}
