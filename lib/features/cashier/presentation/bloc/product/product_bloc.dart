import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/cashier/data/datasources/kasir_local_data_source.dart';
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
  final KasirLocalDataSource localDataSource;

  ProductBloc({
    required this.kasirRepository,
    required this.localDataSource,
  }) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<FetchSubCategoriesEvent>(_onFetchSubCategories);
  }

  Future<void> _onFetchProducts(FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrProducts = await kasirRepository.getAllProducts();
    await failureOrProducts.fold(
      (failure) async {
        emit(ProductError(message: _mapFailureToMessage(failure)));
      },
      (products) async {
        await localDataSource.clearProductsCache();
        await localDataSource.cacheProducts(products);
        emit(ProductLoaded(products: products));
      },
    );
  }

  Future<void> _onFetchCategories(FetchCategoriesEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrCategories = await kasirRepository.getCategories();
    await failureOrCategories.fold(
      (failure) async {
        emit(ProductError(message: _mapFailureToMessage(failure)));
      },
      (categories) async {
        await localDataSource.clearCategoriesCache();
        await localDataSource.cacheCategories(categories);
        emit(CategoryLoaded(categories: categories));
      },
    );
  }

  Future<void> _onFetchSubCategories(FetchSubCategoriesEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrSubCategories = await kasirRepository.getSubCategories();
    await failureOrSubCategories.fold(
      (failure) async {
        emit(ProductError(message: _mapFailureToMessage(failure)));
      },
      (subCategories) async {
        await localDataSource.clearSubCategoriesCache();
        await localDataSource.cacheSubCategories(subCategories);
        emit(SubCategoryLoaded(subCategories: subCategories));
      },
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