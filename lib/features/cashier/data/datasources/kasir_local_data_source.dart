import 'dart:convert';

import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/category_model.dart';
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:akib_pos/features/cashier/data/models/variant_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KasirLocalDataSource {
  final SharedPreferences sharedPreferences;

  KasirLocalDataSource({required this.sharedPreferences});

  // Methods to clear cache for products, categories, sub-categories, additions, and variants
  Future<void> clearProductsCache() async {
    await sharedPreferences.remove('CACHED_PRODUCTS');
  }

  Future<void> clearCategoriesCache() async {
    await sharedPreferences.remove('CACHED_CATEGORIES');
  }

  Future<void> clearSubCategoriesCache() async {
    await sharedPreferences.remove('CACHED_SUB_CATEGORIES');
  }

  Future<void> clearAdditionsCache() async {
    await sharedPreferences.remove('CACHED_ADDITIONS');
  }

  Future<void> clearVariantsCache() async {
    await sharedPreferences.remove('CACHED_VARIANTS');
  }

  Future<void> clearCache() async {
    await clearProductsCache();
    await clearCategoriesCache();
    await clearSubCategoriesCache();
    await clearAdditionsCache();
    await clearVariantsCache();
  }

  // Methods to cache products, categories, sub-categories, additions, and variants
  Future<void> cacheProducts(List<ProductModel> products) async {
    final productsJson = products.map((product) => product.toJson()).toList();
    await sharedPreferences.setString('CACHED_PRODUCTS', json.encode(productsJson));
  }

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final categoriesJson = categories.map((category) => category.toJson()).toList();
    await sharedPreferences.setString('CACHED_CATEGORIES', json.encode(categoriesJson));
  }

  Future<void> cacheSubCategories(List<SubCategoryModel> subCategories) async {
    final subCategoriesJson = subCategories.map((subCategory) => subCategory.toJson()).toList();
    await sharedPreferences.setString('CACHED_SUB_CATEGORIES', json.encode(subCategoriesJson));
  }

  Future<void> cacheAdditions(List<AdditionModel> additions) async {
    final additionsJson = additions.map((addition) => addition.toJson()).toList();
    await sharedPreferences.setString('CACHED_ADDITIONS', json.encode(additionsJson));
  }

  Future<void> cacheVariants(List<VariantModel> variants) async {
    final variantsJson = variants.map((variant) => variant.toJson()).toList();
    await sharedPreferences.setString('CACHED_VARIANTS', json.encode(variantsJson));
  }

  // Methods to get cached products, categories, sub-categories, additions, and variants
  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCTS');
    if (jsonString != null) {
      final List<dynamic> jsonMap = json.decode(jsonString);
      return jsonMap.map((product) => ProductModel.fromJson(product)).toList();
    }
    return [];
  }

  Future<List<CategoryModel>> getCachedCategories() async {
    final jsonString = sharedPreferences.getString('CACHED_CATEGORIES');
    if (jsonString != null) {
      final List<dynamic> jsonMap = json.decode(jsonString);
      return jsonMap.map((category) => CategoryModel.fromJson(category)).toList();
    }
    return [];
  }

  Future<List<SubCategoryModel>> getCachedSubCategories() async {
    final jsonString = sharedPreferences.getString('CACHED_SUB_CATEGORIES');
    if (jsonString != null) {
      final List<dynamic> jsonMap = json.decode(jsonString);
      return jsonMap.map((subCategory) => SubCategoryModel.fromJson(subCategory)).toList();
    }
    return [];
  }

  Future<List<AdditionModel>> getCachedAdditions() async {
    final jsonString = sharedPreferences.getString('CACHED_ADDITIONS');
    if (jsonString != null) {
      final List<dynamic> jsonMap = json.decode(jsonString);
      return jsonMap.map((addition) => AdditionModel.fromJson(addition)).toList();
    }
    return [];
  }

  Future<List<VariantModel>> getCachedVariants() async {
    final jsonString = sharedPreferences.getString('CACHED_VARIANTS');
    if (jsonString != null) {
      final List<dynamic> jsonMap = json.decode(jsonString);
      return jsonMap.map((variant) => VariantModel.fromJson(variant)).toList();
    }
    return [];
  }
}
