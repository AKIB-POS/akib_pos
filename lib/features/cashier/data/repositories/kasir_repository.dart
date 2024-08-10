
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/cashier/data/datasources/kasir_local_data_source.dart';
import 'package:akib_pos/features/cashier/data/datasources/kasir_remote_data_source.dart';
import 'package:akib_pos/features/cashier/data/models/category_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:dartz/dartz.dart';

abstract class KasirRepository {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories();
}

class KasirRepositoryImpl implements KasirRepository {
  final KasirRemoteDataSource remoteDataSource;
  final KasirLocalDataSource localDataSource;

  KasirRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    return await _getProducts(() {
      return remoteDataSource.getAllProducts().then((products) {
        localDataSource.cacheProducts(products);
        return products;
      });
    });
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    return await _getCategories(() {
      return remoteDataSource.getCategories().then((categories) {
        localDataSource.cacheCategories(categories);
        return categories;
      });
    });
  }

  @override
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories() async {
    return await _getSubCategories(() {
      return remoteDataSource.getSubCategories().then((subCategories) {
        localDataSource.cacheSubCategories(subCategories);
        return subCategories;
      });
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
