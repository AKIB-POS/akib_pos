import 'dart:convert';
import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/category_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:akib_pos/features/cashier/data/models/variant_model.dart';
import 'package:akib_pos/util/shared_prefs_helper.dart';
import 'package:http/http.dart' as http;



abstract class KasirRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<List<CategoryModel>> getCategories();
  Future<List<SubCategoryModel>> getSubCategories();
  Future<List<AdditionModel>> getAdditions();
  Future<List<VariantModel>> getVariants();
}

class KasirRemoteDataSourceImpl implements KasirRemoteDataSource {
  final http.Client client;
  final SharedPrefsHelper sharedPrefsHelper;

  KasirRemoteDataSourceImpl({required this.client, required this.sharedPrefsHelper});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await _getFromUrl('${URLs.baseUrlMock}/products');
    return _parseProductList(response);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _getFromUrl('${URLs.baseUrlMock}/categories');
    return _parseCategoryList(response);
  }

  @override
  Future<List<SubCategoryModel>> getSubCategories() async {
    final response = await _getFromUrl('${URLs.baseUrlMock}/sub-categories');
    return _parseSubCategoryList(response);
  }

  @override
  Future<List<AdditionModel>> getAdditions() async {
    final response = await _getFromUrl('${URLs.baseUrlMock}/additions');
    return _parseAdditionList(response);
  }

  @override
  Future<List<VariantModel>> getVariants() async {
    final response = await _getFromUrl('${URLs.baseUrlMock}/variants');
    return _parseVariantList(response);
  }

  Future<http.Response> _getFromUrl(String url) async {
    final token = sharedPrefsHelper.getToken();
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
    return response;
  }

  List<ProductModel> _parseProductList(http.Response response) {
    final jsonData = json.decode(response.body);
    if (jsonData['data'] == null) {
      throw ServerException();
    }
    return (jsonData['data'] as List).map((product) => ProductModel.fromJson(product)).toList();
  }

  List<CategoryModel> _parseCategoryList(http.Response response) {
    final jsonData = json.decode(response.body);
    if (jsonData['data'] == null) {
      throw ServerException();
    }
    return (jsonData['data'] as List).map((category) => CategoryModel.fromJson(category)).toList();
  }

  List<SubCategoryModel> _parseSubCategoryList(http.Response response) {
    final jsonData = json.decode(response.body);
    if (jsonData['data'] == null) {
      throw ServerException();
    }
    return (jsonData['data'] as List).map((subCategory) => SubCategoryModel.fromJson(subCategory)).toList();
  }

  List<AdditionModel> _parseAdditionList(http.Response response) {
    final jsonData = json.decode(response.body);
    if (jsonData['data'] == null) {
      throw ServerException();
    }
    return (jsonData['data'] as List).map((addition) => AdditionModel.fromJson(addition)).toList();
  }

  List<VariantModel> _parseVariantList(http.Response response) {
    final jsonData = json.decode(response.body);
    if (jsonData['data'] == null) {
      throw ServerException();
    }
    return (jsonData['data'] as List).map((variant) => VariantModel.fromJson(variant)).toList();
  }
}
