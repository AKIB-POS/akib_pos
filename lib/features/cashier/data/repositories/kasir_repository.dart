
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/core/error/failures.dart';
import 'package:akib_pos/features/cashier/data/datasources/kasir_local_data_source.dart';
import 'package:akib_pos/features/cashier/data/datasources/kasir_remote_data_source.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/category_model.dart';
import 'package:akib_pos/features/cashier/data/models/close_cashier_response.dart';
import 'package:akib_pos/features/cashier/data/models/expenditure_model.dart';
import 'package:akib_pos/features/cashier/data/models/full_transaction_model.dart';
import 'package:akib_pos/features/cashier/data/models/member_model.dart';
import 'package:akib_pos/features/cashier/data/models/open_cashier_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/redeem_voucher_response.dart';
import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:akib_pos/features/cashier/data/models/variant_model.dart';
import 'package:dartz/dartz.dart';

abstract class KasirRepository {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories();
  Future<Either<Failure, List<VariantModel>>> getVariants();
  Future<Either<Failure, List<AdditionModel>>> getAdditions();
  Future<Either<Failure, RedeemVoucherResponse>> redeemVoucher(String code);
  Future<Either<Failure, List<MemberModel>>> getAllMembers(); // Tambahkan metode ini
  Future<Either<Failure, List<MemberModel>>> searchMemberByName(String name);
  Future<Either<Failure, void>> postMember(String name, String phoneNumber, {String? email});
  Future<Either<Failure, MemberModel>> updateMember(MemberModel member);
  Future<Either<Failure, double>> getTaxAmount();
  Future<Either<Failure, void>> postExpenditure(ExpenditureModel expenditure);
  Future<Either<Failure, void>> postTransaction(FullTransactionModel fullTransaction); 
  Future<Either<Failure, CloseCashierResponse>> closeCashier();
  Future<Either<Failure, OpenCashierResponse>> openCashier(OpenCashierRequest request);
}

class KasirRepositoryImpl implements KasirRepository {
  final KasirRemoteDataSource remoteDataSource;

  KasirRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, OpenCashierResponse>> openCashier(OpenCashierRequest request) async {
    try {
      final response = await remoteDataSource.openCashier(request);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

   @override
  Future<Either<Failure, CloseCashierResponse>> closeCashier() async {
    try {
      final closeCashierResponse = await remoteDataSource.closeCashier();
      return Right(closeCashierResponse);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

   @override
  Future<Either<Failure, double>> getTaxAmount() async {
    try {
      final taxAmount = await remoteDataSource.getTaxAmount();
      return Right(taxAmount);
    } catch (error) {
      return Left(ServerFailure());
    }
  }


  @override
  Future<Either<Failure, void>> postTransaction(FullTransactionModel fullTransaction) async {
    try {
      await remoteDataSource.postTransaction(fullTransaction);
      return Right(null);
    } catch (error) {
      return Left(ServerFailure());
    }
  }
   @override
  Future<Either<Failure, void>> postExpenditure(ExpenditureModel expenditure) async {
    try {
      await remoteDataSource.postExpenditure(expenditure);
      return Right(null);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

 
  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      print("apaaanya $categories");
      return Right(categories);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.getAllProducts();
      return Right(products);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories() async {
    try {
      final subCategories = await remoteDataSource.getSubCategories();
      return Right(subCategories);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<VariantModel>>> getVariants() async {
    try {
      final variants = await remoteDataSource.getVariants();
      return Right(variants);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<AdditionModel>>> getAdditions() async {
    try {
      final additions = await remoteDataSource.getAdditions();
      return Right(additions);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MemberModel>>> getAllMembers() async {
    try {
      final members = await remoteDataSource.getAllMembers();
      return Right(members);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MemberModel>>> searchMemberByName(String name) async {
    try {
      final members = await remoteDataSource.searchMemberByName(name);
      return Right(members);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> postMember(String name, String phoneNumber, {String? email}) async {
    try {
      await remoteDataSource.postMember(name, phoneNumber, email: email);
      return Right(null);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MemberModel>> updateMember(MemberModel member) async {
    try {
      final updatedMember = await remoteDataSource.updateMember(member);
      return Right(updatedMember);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, RedeemVoucherResponse>> redeemVoucher(String code) async {
    try {
      final voucher = await remoteDataSource.redeemVoucher(code);
      return Right(voucher);
    } catch (error) {
      return Left(ServerFailure());
    }
  }
}