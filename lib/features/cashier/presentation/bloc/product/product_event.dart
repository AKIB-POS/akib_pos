part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductsEvent extends ProductEvent {}

class FetchCategoriesEvent extends ProductEvent {}

class FetchSubCategoriesEvent extends ProductEvent {
  const FetchSubCategoriesEvent();

  @override
  List<Object> get props => [];
}

class FetchAdditionsEvent extends ProductEvent {
  const FetchAdditionsEvent();

  @override
  List<Object> get props => [];
}

class FetchVariantsEvent extends ProductEvent {
  const FetchVariantsEvent();

  @override
  List<Object> get props => [];
}
