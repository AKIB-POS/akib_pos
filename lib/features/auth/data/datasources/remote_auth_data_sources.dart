import 'package:akib_pos/features/auth/data/models/auth_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class RemoteAuthDataSource {
  final String baseUrl;

  RemoteAuthDataSource(this.baseUrl);

  Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}