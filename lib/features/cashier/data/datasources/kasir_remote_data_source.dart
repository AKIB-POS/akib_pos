import 'dart:async';
import 'dart:convert';
import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/cash_register_status_response.dart';
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
import 'package:get_it/get_it.dart';
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
  Future<PostCloseCashierResponse> postCloseCashier(OpenCashierRequest request);
  Future<CashRegisterStatusResponse> getCashRegisterStatus();
}

class KasirRemoteDataSourceImpl implements KasirRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  KasirRemoteDataSourceImpl({
    required this.client,
  });
Future<PostCloseCashierResponse> postCloseCashier(OpenCashierRequest request) async {
  final url = '${URLs.baseUrlProd}/close-cashier';

  final response = await client.post(
    Uri.parse(url),
    headers: _buildHeaders(), // Use the same _buildHeaders() method
    body: json.encode(request.toJson()),
  ).timeout(Duration(seconds: 30));

  if (response.statusCode == 201) {
    return PostCloseCashierResponse.fromJson(json.decode(response.body));
  } else {
    throw ServerException();
  }
}
Map<String, String> _buildHeaders() {
    final token = sharedPrefsHelper.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }


 @override
  Future<CashRegisterStatusResponse> getCashRegisterStatus( ) async {
    final token = sharedPrefsHelper.getToken();
    final branch_id = sharedPrefsHelper.getBranchId();
    final url = '${URLs.baseUrlProd}/cash-register/status?branch_id=$branch_id';

    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return CashRegisterStatusResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<OpenCashierResponse> openCashier(OpenCashierRequest request) async {
    const url = '${URLs.baseUrlProd}/open-cashier';
    final token = sharedPrefsHelper.getToken();
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Jika permintaan berhasil
        return OpenCashierResponse.fromJson(json.decode(response.body));
      } else {
        // Tangani status kode lainnya, mungkin ada redirect atau masalah lain
        throw Exception(
            'Failed to open cashier with status code ${response.statusCode}');
      }
    } catch (e) {
      // Tangani error lain yang mungkin terjadi
      throw Exception('Failed to open cashier: $e');
    }
  }

  @override
  Future<CloseCashierResponse> closeCashier() async {
    final url =
        '${URLs.baseUrlProd}/close-cashier/${sharedPrefsHelper.getCachedCashRegisterId()}';
    final response = await client.get(Uri.parse(url), headers: _buildHeaders());

    if (response.statusCode != 200) {
      throw ServerException();
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    return CloseCashierResponse.fromJson(jsonResponse);
  }

 @override
Future<double> getTaxAmount() async {
  final url = '${URLs.baseUrlProd}/tax-service';
  final response = await client.get(Uri.parse(url), headers: _buildHeaders());

  if (response.statusCode != 200) {
    throw ServerException();
  }

  final Map<String, dynamic> jsonResponse = json.decode(response.body);
  
  // Mendapatkan nilai amount
  final amount = jsonResponse['data']['amount'];

  // Jika nilai amount adalah integer, konversi ke double
  if (amount is int) {
    return amount.toDouble();  // Konversi integer ke double
  } else if (amount is double) {
    return amount;  // Jika sudah double, langsung kembalikan
  } else {
    throw FormatException('Invalid tax amount format'); // Jika formatnya tidak valid
  }
}


  @override
  Future<void> postTransaction(FullTransactionModel fullTransaction) async {
    final url = '${URLs.baseUrlProd}/transactions';
    final response = await client.post(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: jsonEncode(
          fullTransaction.toApiJson()), // Convert to JSON using toApiJson
    );

    if (response.statusCode != 201) {
      throw ServerException(); // Handle failure by throwing an exception
    }
  }

  @override
  Future<void> postExpenditure(ExpenditureModel expenditure) async {
    final url = '${URLs.baseUrlProd}/expenses';
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
  Future<void> postMember(String name, String phoneNumber,
      {String? email}) async {
    final url = '${URLs.baseUrlProd}/members';
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
    final url = '${URLs.baseUrlProd}/members/${member.id}';
    final response = await client.put(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: json.encode(member.toUpdateJson()),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    return MemberModel.fromJson(json.decode(response.body)['data']);
  }

  @override
  Future<List<MemberModel>> getAllMembers() async {
    final response = await _getFromUrl('${URLs.baseUrlProd}/members');
    return _parseMemberList(response);
  }

  @override
  Future<List<MemberModel>> searchMemberByName(String name) async {
    final response =
        await _getFromUrl('${URLs.baseUrlProd}/members?name=$name');
    return _parseMemberList(response);
  }

  List<MemberModel> _parseMemberList(http.Response response) {
    final Map<String, dynamic> decodedResponse = json.decode(response.body);
    final List<dynamic> membersJson = decodedResponse['data'];
    return membersJson
        .map<MemberModel>((json) => MemberModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await _getFromUrl('${URLs.baseUrlProd}/products');
    return _parseProductList(response);
  }

  @override
  Future<RedeemVoucherResponse> redeemVoucher(String code) async {
    // final url = '${URLs.baseUrlProd}/redeem-voucher/$code';
    // final response = await _postFromUrl(url)
    // ;
    const url = '${URLs.baseUrlProd}/redeem-voucher';
    final response = await client.post(
      Uri.parse(url),
      headers: _buildHeaders(),
      body: jsonEncode({
        'code': code,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    return RedeemVoucherResponse.fromJson(json.decode(response.body));
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _getFromUrl('${URLs.baseUrlProd}/categories');
    return _parseCategoryList(response);
  }

  @override
  Future<List<SubCategoryModel>> getSubCategories() async {
    final response = await _getFromUrl('${URLs.baseUrlProd}/sub-categories');
    return _parseSubCategoryList(response);
  }

  @override
  Future<List<AdditionModel>> getAdditions() async {
    final response = await _getFromUrl('${URLs.baseUrlProd}/additions');
    return _parseAdditionList(response);
  }

  @override
  Future<List<VariantModel>> getVariants() async {
    final response = await _getFromUrl('${URLs.baseUrlProd}/variants');
    return _parseVariantList(response);
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
    final response =
        await client.post(Uri.parse(url), headers: _buildHeaders());

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
    return (jsonData['data'] as List)
        .map((product) => ProductModel.fromJson(product))
        .toList();
  }

  List<CategoryModel> _parseCategoryList(http.Response response) {
    final jsonData = json.decode(response.body);
    if (jsonData['data'] == null) {
      throw ServerException();
    }
    return (jsonData['data'] as List)
        .map((category) => CategoryModel.fromJson(category))
        .toList();
  }

  List<SubCategoryModel> _parseSubCategoryList(http.Response response) {
    final jsonData = json.decode(response.body);
    if (jsonData['data'] == null) {
      throw ServerException();
    }
    return (jsonData['data'] as List)
        .map((subCategory) => SubCategoryModel.fromJson(subCategory))
        .toList();
  }

  List<AdditionModel> _parseAdditionList(http.Response response) {
    final jsonData = json.decode(response.body);
    print("apanyaa $jsonData");
    if (jsonData['data'] == null) {
      throw ServerException();
    }
    print(
        "errornyaa ${(jsonData['data'] as List).map((addition) => AdditionModel.fromJson(addition)).toList()}");
    return (jsonData['data'] as List)
        .map((addition) => AdditionModel.fromJson(addition))
        .toList();
  }

  List<VariantModel> _parseVariantList(http.Response response) {
    final jsonData = json.decode(response.body);
    if (jsonData['data'] == null) {
      throw ServerException();
    }
    return (jsonData['data'] as List)
        .map((variant) => VariantModel.fromJson(variant))
        .toList();
  }
}
