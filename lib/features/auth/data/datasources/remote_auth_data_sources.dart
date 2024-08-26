import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class RemoteAuthDataSource {
  final String baseUrl;

  RemoteAuthDataSource(this.baseUrl);

  Future<LoginResponse> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String phone = '',
    String companyName = "-",
    String? companyEmail,
    String companyPhone = "-",
    String companyAddress = "-"
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/register'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'name': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
        'company_name': companyName,
        'company_email': companyEmail ?? email,
        'company_phone': companyPhone,
        'company_address': companyAddress,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/forgotPassword'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to send reset password link');
    }
  }
}