import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class RemoteAuthDataSource {
  Future<LoginResponse> login({required String email, required String password});
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String phone,
    String companyName,
    String? companyEmail,
    String companyPhone,
    String companyAddress,
  });
  Future<bool> forgotPassword({required String email});
}

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final http.Client client;

  RemoteAuthDataSourceImpl({
    required this.client,
  });

  @override
  Future<LoginResponse> login({required String email, required String password}) async {
    String? deviceId;
    try {
      deviceId = await DeviceInformation.deviceIMEINumber;
    } on PlatformException {
         throw GeneralException('Gagal Mendapatkan Device Id');
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   deviceId = await PlatformDeviceId.getDeviceId;
    // } on PlatformException {
    //   deviceId = 'Failed to get deviceId.';
    // }
    final response = await http.post(
      Uri.parse('${URLs.baseUrlProd}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'device_id' : deviceId

      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      throw GeneralException(errorResponse['message'] ?? 'Failed to login');
    }
  }

  @override
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String phone = '',
    String companyName = "-",
    String? companyEmail,
    String companyPhone = "-",
    String companyAddress = "-",
  }) async {
    final response = await http.post(
      Uri.parse('${URLs.baseUrlProd}/register'),
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

    if (response.statusCode == 201) {
      return true;
    } else {
      final errorResponse = jsonDecode(response.body);
      throw GeneralException(errorResponse['message'] ?? 'Failed to register');
    }
  }

  @override
  Future<bool> forgotPassword({required String email}) async {
    final response = await http.post(
      Uri.parse('${URLs.baseUrlProd}/forgotPassword'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final errorResponse = jsonDecode(response.body);
      throw GeneralException(errorResponse['message'] ?? 'Failed to send reset password link');
    }
  }
}
