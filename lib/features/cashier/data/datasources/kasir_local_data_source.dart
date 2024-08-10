// Local Data Source
import 'dart:convert';

import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/cashier/data/models/category_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KasirLocalDataSource {
  final SharedPreferences sharedPreferences;

  KasirLocalDataSource({required this.sharedPreferences});

  Future<void> cacheProducts(List<ProductModel> products) async {
    final productJsonList = products.map((product) => product.toJson()).toList();
    await sharedPreferences.setString('CACHED_PRODUCTS', json.encode(productJsonList));
  }

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final categoryJsonList = categories.map((category) => category.toJson()).toList();
    await sharedPreferences.setString('CACHED_CATEGORIES', json.encode(categoryJsonList));
  }

  Future<void> cacheSubCategories(List<SubCategoryModel> subCategories) async {
    final subCategoryJsonList = subCategories.map((subCategory) => subCategory.toJson()).toList();
    await sharedPreferences.setString('CACHED_SUB_CATEGORIES', json.encode(subCategoryJsonList));
  }

  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCTS');
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString) as List;
      return decodedJson.map((jsonProduct) => ProductModel.fromJson(jsonProduct)).toList();
    }
    return [];
  }

  Future<List<CategoryModel>> getCachedCategories() async {
    final jsonString = sharedPreferences.getString('CACHED_CATEGORIES');
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString) as List;
      return decodedJson.map((jsonCategory) => CategoryModel.fromJson(jsonCategory)).toList();
    }
    return [];
  }

  Future<List<SubCategoryModel>> getCachedSubCategories() async {
    final jsonString = sharedPreferences.getString('CACHED_SUB_CATEGORIES');
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString) as List;
      return decodedJson.map((jsonSubCategory) => SubCategoryModel.fromJson(jsonSubCategory)).toList();
    }
    return [];
  }

  Future<void> clearProductsCache() async {
    await sharedPreferences.remove('CACHED_PRODUCTS');
  }

  Future<void> clearCategoriesCache() async {
    await sharedPreferences.remove('CACHED_CATEGORIES');
  }

  Future<void> clearSubCategoriesCache() async {
    await sharedPreferences.remove('CACHED_SUB_CATEGORIES');
  }

  Future<void> clearCache() async {
    await clearProductsCache();
    await clearCategoriesCache();
    await clearSubCategoriesCache();
  }
}
