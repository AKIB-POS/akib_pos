
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/cashier/data/datasources/kasir_local_data_source.dart';
import 'package:akib_pos/features/cashier/data/datasources/kasir_remote_data_source.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/category_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:akib_pos/features/cashier/data/models/variant_model.dart';
import 'package:dartz/dartz.dart';

abstract class KasirRepository {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories();
  Future<Either<Failure, List<VariantModel>>> getVariants();
  Future<Either<Failure, List<AdditionModel>>> getAdditions();
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

  @override
  Future<Either<Failure, List<VariantModel>>> getVariants() async {
    return await _getVariants(() {
      return remoteDataSource.getVariants().then((variants) {
        localDataSource.cacheVariants(variants);
        return variants;
      });
    });
  }

  @override
  Future<Either<Failure, List<AdditionModel>>> getAdditions() async {
    return await _getAdditions(() {
      return remoteDataSource.getAdditions().then((additions) {
        localDataSource.cacheAdditions(additions);
        return additions;
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

  Future<Either<Failure, List<VariantModel>>> _getVariants(
      Future<List<VariantModel>> Function() getVariants) async {
    try {
      final variants = await getVariants();
      return Right(variants);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, List<AdditionModel>>> _getAdditions(
      Future<List<AdditionModel>> Function() getAdditions) async {
    try {
      final additions = await getAdditions();
      return Right(additions);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(NetworkFailure());
    }
  }
}
