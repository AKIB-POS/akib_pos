import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSharedPref {
  final SharedPreferences _prefs;

  AuthSharedPref(this._prefs);

  static const String tokenKey = 'authToken';
  static const String idKey = 'userId';
  static const String companyIdKey = 'companyId';
  static const String branchIdKey = 'branchId';
  static const String emailKey = 'email';
  static const String roleKey = 'role';
  static const String permissionsKey = 'permissions';
  static const String isLoggedInKey = 'isLoggedIn';

  Future<void> saveLoginResponse(LoginResponse response) async {
    await _prefs.setBool(isLoggedInKey, true);
    await _prefs.setString(tokenKey, response.token);
    await _prefs.setInt(idKey, response.id);
    await _prefs.setInt(companyIdKey, response.companyId);
    await _prefs.setInt(branchIdKey, response.branchId);
    await _prefs.setString(emailKey, response.email ?? '');
    await _prefs.setString(roleKey, response.role ?? '');
    await _prefs.setStringList(permissionsKey, response.permissions);
  }

  Future<void> clearLoginResponse() async {
    await _prefs.setBool(isLoggedInKey, false);
    await _prefs.remove(tokenKey);
    await _prefs.remove(idKey);
    await _prefs.remove(companyIdKey);
    await _prefs.remove(branchIdKey);
    await _prefs.remove(emailKey);
    await _prefs.remove(roleKey);
    await _prefs.remove(permissionsKey);
  }

  bool isLoggedIn() {
    return _prefs.getBool(isLoggedInKey) ?? false;
  }

  String? getToken() {
    return _prefs.getString(tokenKey);
  }

  int? getUserId() {
    return _prefs.getInt(idKey);
  }

  int? getCompanyId() {
    return _prefs.getInt(companyIdKey);
  }

  int? getBranchId() {
    return _prefs.getInt(branchIdKey);
  }

  String? getEmail() {
    return _prefs.getString(emailKey);
  }

  String? getRole() {
    return _prefs.getString(roleKey);
  }

  List<String>? getPermissions() {
    return _prefs.getStringList(permissionsKey);
  }
}