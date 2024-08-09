
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/cashier/data/datasources/kasir_remote_data_source.dart';
import 'package:akib_pos/features/cashier/data/models/category_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:dartz/dartz.dart';

abstract class KasirRepository {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories(int categoryId);
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(int categoryId);
  Future<Either<Failure, List<ProductModel>>> getProductsBySubCategory(int subCategoryId);
  Future<Either<Failure, List<ProductModel>>> searchProductsByName(String productName);
}

class KasirRepositoryImpl implements KasirRepository {
  final KasirRemoteDataSource remoteDataSource;

  KasirRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    return await _getProducts(() {
      return remoteDataSource.getAllProducts();
    });
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    return await _getCategories(() {
      return remoteDataSource.getCategories();
    });
  }

  @override
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories(int categoryId) async {
    return await _getSubCategories(() {
      return remoteDataSource.getSubCategories(categoryId);
    });
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(int categoryId) async {
    return await _getProducts(() {
      return remoteDataSource.getProductsByCategory(categoryId);
    });
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsBySubCategory(int subCategoryId) async {
    return await _getProducts(() {
      return remoteDataSource.getProductsBySubCategory(subCategoryId);
    });
  }

  @override
  Future<Either<Failure, List<ProductModel>>> searchProductsByName(String productName) async {
    return await _getProducts(() {
      return remoteDataSource.searchProductsByName(productName);
    });
  }

  Future<Either<Failure, List<ProductModel>>> _getProducts(
      Future<List<ProductModel>> Function() getProducts) async {
    try {
      final products = await getProducts();
      return Right(products);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, List<CategoryModel>>> _getCategories(
      Future<List<CategoryModel>> Function() getCategories) async {
    try {
      final categories = await getCategories();
      return Right(categories);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, List<SubCategoryModel>>> _getSubCategories(
      Future<List<SubCategoryModel>> Function() getSubCategories) async {
    try {
      final subCategories = await getSubCategories();
      return Right(subCategories);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(NetworkFailure());
    }
  }
}