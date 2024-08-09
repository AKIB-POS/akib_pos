part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductsEvent extends ProductEvent {}

class FetchCategoriesEvent extends ProductEvent {}

class FetchSubCategoriesEvent extends ProductEvent {
  final int categoryId;

  FetchSubCategoriesEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class SearchProductsEvent extends ProductEvent {
  final String searchText;

  SearchProductsEvent(this.searchText);

  @override
  List<Object> get props => [searchText];
}

class FetchProductsByCategoryEvent extends ProductEvent {
  final int categoryId;

  FetchProductsByCategoryEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class FetchProductsBySubCategoryEvent extends ProductEvent {
  final int subCategoryId;

  FetchProductsBySubCategoryEvent(this.subCategoryId);

  @override
  List<Object> get props => [subCategoryId];
}
