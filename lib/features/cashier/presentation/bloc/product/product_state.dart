part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;

  ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class CategoryLoaded extends ProductState {
  final List<CategoryModel> categories;

  CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class SubCategoryLoaded extends ProductState {
  final List<SubCategoryModel> subCategories;

  SubCategoryLoaded({required this.subCategories});

  @override
  List<Object> get props => [subCategories];
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
