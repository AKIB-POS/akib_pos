import 'dart:convert';

import 'package:akib_pos/api/urls.dart';
import 'package:akib_pos/core/error/exceptions.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/settings/data/models/change_password_request.dart';
import 'package:akib_pos/features/settings/data/models/personal_information.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

abstract class SettingRemoteDataSource {
  Future<PersonalInformationResponse> getPersonalInformation();
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);
}

class SettingRemoteDataSourceImpl implements SettingRemoteDataSource {
  final http.Client client;
  final AuthSharedPref sharedPrefsHelper = GetIt.instance<AuthSharedPref>();

  SettingRemoteDataSourceImpl({required this.client});

  @override
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request) async {
    const url = '${URLs.baseUrlProd}/change-password';
    final response = await client.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${sharedPrefsHelper.getToken()}',
      },
      body: request.toJson(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ChangePasswordResponse.fromJson(jsonResponse);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PersonalInformationResponse> getPersonalInformation() async {
    const url = '${URLs.baseUrlProd}/personal-information';
    final response = await client.get(
      Uri.parse(url),
      headers: _buildHeaders(),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PersonalInformationResponse.fromJson(jsonResponse['data']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw GeneralException(json.decode(response.body)['message']);
    } else {
      throw ServerException();
    }
  }

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefsHelper.getToken()}',
    };
  }
}
