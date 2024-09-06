import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/accounting/data/models/expenditure_report/purchased_product_model.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchasedProductCubit extends Cubit<PurchasedProductState> {
  final AccountingRepository repository;

  PurchasedProductCubit({required this.repository}) : super(PurchasedProductInitial());

  void fetchPurchasedProducts({
    required int branchId,
    required int companyId,
    required String date,
  }) async {
    emit(PurchasedProductLoading());

    final result = await repository.getPurchasedProducts(
      branchId: branchId,
      companyId: companyId,
      date: date,
    );

    result.fold(
      (failure) {
        if (failure is GeneralFailure) {
          emit(PurchasedProductError(failure.message));
        } else {
          emit(PurchasedProductError('Failed to fetch purchased products.'));
        }
      },
      (products) {
        emit(PurchasedProductSuccess(products));
      },
    );
  }
}

abstract class PurchasedProductState {}

class PurchasedProductInitial extends PurchasedProductState {}

class PurchasedProductLoading extends PurchasedProductState {}

class PurchasedProductSuccess extends PurchasedProductState {
  final List<PurchasedProductModel> products;

  PurchasedProductSuccess(this.products);
}

class PurchasedProductError extends PurchasedProductState {
  final String message;

  PurchasedProductError(this.message);
}
