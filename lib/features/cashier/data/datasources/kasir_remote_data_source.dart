import 'dart:async';
import 'dart:convert';
import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
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
import 'package:akib_pos/util/shared_prefs_helper.dart';
import 'package:http/http.dart' as http;



abstract class KasirRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<List<CategoryModel>> getCategories();
  Future<List<SubCategoryModel>> getSubCategories();
  Future<List<AdditionModel>> getAdditions();
  Future<List<VariantModel>> getVariants();
  Future<RedeemVoucherResponse> redeemVoucher(String code);
  Future<List<MemberModel>> getAllMembers();
  Future<List<MemberModel>> searchMemberByName(String name);
  Future<void> postMember(String name, String phoneNumber, {String? email});
  Future<MemberModel> updateMember(MemberModel member);
  Future<double> getTaxAmount();
  Future<void> postExpenditure(ExpenditureModel expenditure);
  Future<void> postTransaction(FullTransactionModel fullTransaction);
  Future<CloseCashierResponse> closeCashier();
  Future<OpenCashierResponse> openCashier(OpenCashierRequest request);
}

class KasirRemoteDataSourceImpl implements KasirRemoteDataSource {
  final http.Client client;
  final SharedPrefsHelper sharedPrefsHelper;

  KasirRemoteDataSourceImpl({
    required this.client,
    required this.sharedPrefsHelper,
  });

   @override
  Future<CloseCashierResponse> closeCashier() async {
    final url = '${URLs.baseUrlMock}/close-cashier';  // Adjust the URL as necessary
    final response = await client.get(Uri.parse(url), headers: _buildHeaders());

    if (response.statusCode != 200) {
      throw ServerException();
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    return CloseCashierResponse.fromJson(jsonResponse);
  }

  @override
  Future<double> getTaxAmount() async {
    final url = '${URLs.baseUrlMock}/tax';
    final response = await client.get(Uri.parse(url), headers: _buildHeaders());

    if (response.statusCode != 200) {
      throw ServerException();
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse['data']['amount'];
  }

   

   @override
  Future<void> postTransaction(FullTransactionModel fullTransaction) async {
    final url = '${URLs.baseUrlMock}/transactions';
    final response = await client.post(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: jsonEncode(fullTransaction.toApiJson()), // Convert to JSON using toApiJson
    );

    if (response.statusCode != 201) {
      throw ServerException(); // Handle failure by throwing an exception
    }
  }

   @override
  Future<void> postExpenditure(ExpenditureModel expenditure) async {
    final url = '${URLs.baseUrlMock}/expenditures';
    final response = await client.post(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: jsonEncode(expenditure.toJson()),
    );

    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  

  @override
  Future<void> postMember(String name, String phoneNumber, {String? email}) async {
    final url = '${URLs.baseUrlMock}/members';
    final response = await client.post(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: jsonEncode({
        'name': name,
        'phone_number': phoneNumber,
        'email': email,
      }),
    );

    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<MemberModel> updateMember(MemberModel member) async {
    final url = '${URLs.baseUrlMock}/members/${member.id}';
    final response = await client.put(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: json.encode(member.toJson()),
    );

    if (response.statusCode != 201) {
      throw ServerException();
    }

    return MemberModel.fromJson(json.decode(response.body)['data']);
  }

  @override
  Future<List<MemberModel>> getAllMembers() async {
    final response = await _getFromUrl('${URLs.baseUrlMock}/members');
    return _parseMemberList(response);
  }

  @override
  Future<List<MemberModel>> searchMemberByName(String name) async {
    final response = await _getFromUrl('${URLs.baseUrlMock}/members?name=$name');
    return _parseMemberList(response);
  }

  List<MemberModel> _parseMemberList(http.Response response) {
    final Map<String, dynamic> decodedResponse = json.decode(response.body);
    final List<dynamic> membersJson = decodedResponse['data'];
    return membersJson.map<MemberModel>((json) => MemberModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await _getFromUrl('${URLs.baseUrlMock}/products');
    return _parseProductList(response);
  }

  @override
  Future<RedeemVoucherResponse> redeemVoucher(String code) async {
    final url = '${URLs.baseUrlMock}/redeem-voucher/$code';
    final response = await _postFromUrl(url);

    if (response.statusCode != 200) {
      throw ServerException();
    }

    return RedeemVoucherResponse.fromJson(json.decode(response.body));
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

 

  Map<String, String> _buildHeaders() {
    final token = sharedPrefsHelper.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

Future<http.Response> _getFromUrl(String url) async {
  try {
    final response = await client
        .get(Uri.parse(url), headers: _buildHeaders())
        .timeout(Duration(seconds: 15)); // Set a 15-second timeout

    if (response.statusCode != 200) {
      throw ServerException();
    }
    return response;
  } on TimeoutException catch (_) {
    throw TimeoutException('The connection has timed out, Please try again!');
  } catch (e) {
    throw ServerException(); // Handle other potential errors
  }
}

  Future<http.Response> _postFromUrl(String url) async {
    final response = await client.post(Uri.parse(url), headers: _buildHeaders());

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
  
   @override
  Future<OpenCashierResponse> openCashier(OpenCashierRequest request) async {
    final url = '${URLs.baseUrlMock}/open-cashier';
    final response = await client.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return OpenCashierResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
  
  
}