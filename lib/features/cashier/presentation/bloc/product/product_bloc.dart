import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/cashier/data/models/category_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final KasirRepository kasirRepository;

  ProductBloc({required this.kasirRepository}) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<FetchSubCategoriesEvent>(_onFetchSubCategories);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FetchProductsByCategoryEvent>(_onFetchProductsByCategory);
    on<FetchProductsBySubCategoryEvent>(_onFetchProductsBySubCategory);
  }

  void _onFetchProducts(FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrProducts = await kasirRepository.getAllProducts();
    emit(failureOrProducts.fold(
      (failure) => ProductError(message: _mapFailureToMessage(failure)),
      (products) => ProductLoaded(products: products),
    ));
  }

  void _onFetchCategories(FetchCategoriesEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrCategories = await kasirRepository.getCategories();
    emit(failureOrCategories.fold(
      (failure) => ProductError(message: _mapFailureToMessage(failure)),
      (categories) => CategoryLoaded(categories: categories),
    ));
  }

  void _onFetchSubCategories(FetchSubCategoriesEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrSubCategories = await kasirRepository.getSubCategories(event.categoryId);
    emit(failureOrSubCategories.fold(
      (failure) => ProductError(message: _mapFailureToMessage(failure)),
      (subCategories) => SubCategoryLoaded(subCategories: subCategories),
    ));
  }

  void _onSearchProducts(SearchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrProducts = await kasirRepository.searchProductsByName(event.searchText);
    emit(failureOrProducts.fold(
      (failure) => ProductError(message: _mapFailureToMessage(failure)),
      (products) => ProductLoaded(products: products),
    ));
  }

  void _onFetchProductsByCategory(FetchProductsByCategoryEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrProducts = await kasirRepository.getProductsByCategory(event.categoryId);
    emit(failureOrProducts.fold(
      (failure) => ProductError(message: _mapFailureToMessage(failure)),
      (products) => ProductLoaded(products: products),
    ));
  }

  void _onFetchProductsBySubCategory(FetchProductsBySubCategoryEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrProducts = await kasirRepository.getProductsBySubCategory(event.subCategoryId);
    emit(failureOrProducts.fold(
      (failure) => ProductError(message: _mapFailureToMessage(failure)),
      (products) => ProductLoaded(products: products),
    ));
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
