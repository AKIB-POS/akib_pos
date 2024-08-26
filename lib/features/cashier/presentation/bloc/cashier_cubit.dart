import 'dart:async';

import 'package:akib_pos/features/cashier/data/datasources/kasir_local_data_source.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/category_model.dart';
import 'package:akib_pos/features/cashier/data/models/menu_item_exmpl.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:akib_pos/features/cashier/data/models/variant_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/product/product_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CashierCubit extends Cubit<CashierState> {
  final KasirLocalDataSource localDataSource;
  final ProductBloc productBloc;

  CashierCubit({required this.localDataSource, required this.productBloc}) : super(CashierState());

  Future<void> loadData() async {
    // Reset the state to the initial state before reloading
    emit(CashierState());

    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _fetchDataFromApi();
      final categories = await localDataSource.getCachedCategories();
      final subCategories = await localDataSource.getCachedSubCategories();
      final products = await localDataSource.getCachedProducts();
      final additions = await localDataSource.getCachedAdditions();
      final variants = await localDataSource.getCachedVariants();
      final taxAmount = await localDataSource.getCachedTaxAmount();

      emit(state.copyWith(
        categories: categories,
        subCategories: subCategories,
        menuItems: products,
        additions: additions,
        variants: variants,
        taxAmount: taxAmount,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _fetchDataFromApi() async {
    await localDataSource.clearCache();

    final Completer<void> completer = Completer<void>();
    final timer = Timer(Duration(seconds: 15), () {
      if (!completer.isCompleted) {
        completer.completeError('Timeout: Data loading took too long');
      }
    });

    bool isProductLoaded = false;
    bool isCategoryLoaded = false;
    bool isSubCategoryLoaded = false;
    bool isAdditionLoaded = false;
    bool isVariantLoaded = false;
    bool isTaxLoaded = false;

    productBloc.add(FetchCategoriesEvent());
    productBloc.add(FetchSubCategoriesEvent());
    productBloc.add(FetchProductsEvent());
    productBloc.add(FetchAdditionsEvent());
    productBloc.add(FetchVariantsEvent());
    productBloc.add(FetchTaxEvent());

    StreamSubscription? subscription;
    subscription = productBloc.stream.listen((state) async {
      if (state is ProductLoaded) {
        isProductLoaded = true;
        await localDataSource.cacheProducts(state.products);
      } else if (state is CategoryLoaded) {
        isCategoryLoaded = true;
        await localDataSource.cacheCategories(state.categories);
      } else if (state is SubCategoryLoaded) {
        isSubCategoryLoaded = true;
        await localDataSource.cacheSubCategories(state.subCategories);
      } else if (state is AdditionLoaded) {
        isAdditionLoaded = true;
        await localDataSource.cacheAdditions(state.additions);
      } else if (state is VariantLoaded) {
        isVariantLoaded = true;
        await localDataSource.cacheVariants(state.variants);
      } else if (state is TaxLoaded) {
        isTaxLoaded = true;
        await localDataSource.cacheTaxAmount(state.taxAmount);
      } else if (state is ProductError) {
        emit(this.state.copyWith(error: state.message, isLoading: false));
        if (!completer.isCompleted) {
          completer.completeError(state.message);
        }
        subscription?.cancel();
        timer.cancel();
        return;
      }

      if (isProductLoaded && isCategoryLoaded && isSubCategoryLoaded && isAdditionLoaded && isVariantLoaded && isTaxLoaded) {
        if (!completer.isCompleted) {
          completer.complete();
        }
        subscription?.cancel();
        timer.cancel();
      }
    });

    try {
      await completer.future;
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString(), isLoading: false));
    } finally {
      timer.cancel();
    }
  }

  void updateSearchText(String newText) {
    emit(state.copyWith(searchText: newText, selectedSubCategory: 0));
  }

  void updateCategory(int categoryId) {
    emit(state.copyWith(selectedCategory: categoryId, selectedSubCategory: 0));
  }

  void updateSubCategory(int subCategoryId) {
    emit(state.copyWith(selectedSubCategory: subCategoryId, searchText: ''));
  }

  List<ProductModel> get filteredItems {
    final searchText = state.searchText.toLowerCase();
    final selectedCategory = state.selectedCategory;
    final selectedSubCategory = state.selectedSubCategory;

    return state.menuItems.where((item) {
      final matchesCategory = selectedCategory == 0 || item.categoryId == selectedCategory;
      final matchesSubCategory = selectedSubCategory == 0 || item.subCategoryId == selectedSubCategory;
      final matchesSearch = item.name.toLowerCase().contains(searchText);

      return matchesCategory && matchesSubCategory && matchesSearch;
    }).toList();
  }
}

class CashierState {
  final String searchText;
  final int selectedCategory;
  final int selectedSubCategory;
  final List<ProductModel> menuItems;
  final List<CategoryModel> categories;
  final List<SubCategoryModel> subCategories;
  final List<AdditionModel> additions;
  final List<VariantModel> variants;
  final double taxAmount; // New field for tax amount
  final String? error;
  final bool isLoading;

  CashierState({
    this.searchText = '',
    this.selectedCategory = 0,
    this.selectedSubCategory = 0,
    this.menuItems = const [],
    this.categories = const [],
    this.subCategories = const [],
    this.additions = const [],
    this.variants = const [],
    this.taxAmount = 0,
    this.error,
    this.isLoading = false,
  });

  CashierState copyWith({
    String? searchText,
    int? selectedCategory,
    int? selectedSubCategory,
    List<ProductModel>? menuItems,
    List<CategoryModel>? categories,
    List<SubCategoryModel>? subCategories,
    List<AdditionModel>? additions,
    List<VariantModel>? variants,
    double? taxAmount,
    String? error,
    bool? isLoading,
  }) {
    return CashierState(
      searchText: searchText ?? this.searchText,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      menuItems: menuItems ?? this.menuItems,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      additions: additions ?? this.additions,
      variants: variants ?? this.variants,
      taxAmount: taxAmount ?? this.taxAmount,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
