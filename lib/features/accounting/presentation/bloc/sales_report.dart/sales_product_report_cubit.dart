import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/sales_report/sold_product_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesProductReportCubit extends Cubit<SalesProductReportState> {
  final AccountingRepository repository;

  SalesProductReportCubit({required this.repository})
      : super(SalesProductReportInitial());

  void fetchSoldProducts({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    emit(SalesProductReportLoading());

    final result = await repository.getSoldProducts(
      branchId: branchId,
      companyId: companyId,
      date: date,
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(SalesProductReportError(failure.message));
        } else {
          emit(SalesProductReportError('Failed to fetch sold products.'));
        }
      },
      (products) {
        emit(SalesProductReportSuccess(products));
      },
    );
  }
}

abstract class SalesProductReportState {}

class SalesProductReportInitial extends SalesProductReportState {}

class SalesProductReportLoading extends SalesProductReportState {}

class SalesProductReportSuccess extends SalesProductReportState {
  final List<SoldProductModel> products;

  SalesProductReportSuccess(this.products);
}

class SalesProductReportError extends SalesProductReportState {
  final String message;

  SalesProductReportError(this.message);
}
