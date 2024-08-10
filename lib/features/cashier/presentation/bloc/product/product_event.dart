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
