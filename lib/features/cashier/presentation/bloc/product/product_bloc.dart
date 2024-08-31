import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/cashier/data/datasources/local/kasir_local_data_source.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/cash_register_status_response.dart';
import 'package:akib_pos/features/cashier/data/models/category_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:akib_pos/features/cashier/data/models/variant_model.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final KasirRepository kasirRepository;
  final KasirLocalDataSource localDataSource;

  ProductBloc({
    required this.kasirRepository,
    required this.localDataSource,
  }) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<FetchSubCategoriesEvent>(_onFetchSubCategories);
    on<FetchAdditionsEvent>(_onFetchAdditions);
    on<FetchVariantsEvent>(_onFetchVariants);
    on<FetchTaxEvent>(_onFetchTax);
    on<FetchCashRegisterStatusEvent>(_onFetchCashRegisterStatus);
  }


Future<void> _onFetchCashRegisterStatus(
    FetchCashRegisterStatusEvent event, Emitter<ProductState> emit) async {
  emit(ProductLoading());
  final failureOrStatus = await kasirRepository.getCashRegisterStatus();
  failureOrStatus.fold(
    (failure) => emit(ProductError(message: _mapFailureToMessage(failure))),
    (status) => emit(CashRegisterStatusLoaded(status: status)),
  );
}


 Future<void> _onFetchProducts(FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrProducts = await kasirRepository.getAllProducts();
    failureOrProducts.fold(
      (failure) => emit(ProductError(message: _mapFailureToMessage(failure))),
      (products) => emit(ProductLoaded(products: products)),
    );
  }

  Future<void> _onFetchCategories(FetchCategoriesEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrCategories = await kasirRepository.getCategories();
    failureOrCategories.fold(
      (failure) => emit(ProductError(message: _mapFailureToMessage(failure))),
      (categories) => emit(CategoryLoaded(categories: categories)),
    );
  }

  Future<void> _onFetchSubCategories(FetchSubCategoriesEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrSubCategories = await kasirRepository.getSubCategories();
    failureOrSubCategories.fold(
      (failure) => emit(ProductError(message: _mapFailureToMessage(failure))),
      (subCategories) => emit(SubCategoryLoaded(subCategories: subCategories)),
    );
  }

  Future<void> _onFetchAdditions(FetchAdditionsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrAdditions = await kasirRepository.getAdditions();
    failureOrAdditions.fold(
      (failure) => emit(ProductError(message: _mapFailureToMessage(failure))),
      (additions) => emit(AdditionLoaded(additions: additions)),
    );
  }

  Future<void> _onFetchVariants(FetchVariantsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrVariants = await kasirRepository.getVariants();
    failureOrVariants.fold(
      (failure) => emit(ProductError(message: _mapFailureToMessage(failure))),
      (variants) => emit(VariantLoaded(variants: variants)),
    );
  }

  Future<void> _onFetchTax(FetchTaxEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrTax = await kasirRepository.getTaxAmount();
    failureOrTax.fold(
      (failure) => emit(ProductError(message: _mapFailureToMessage(failure))),
      (taxAmount) => emit(TaxLoaded(taxAmount: taxAmount)),
    );
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      case NetworkFailure:
        return 'Network Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
