import 'dart:convert';

import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:akib_pos/features/dashboard/data/models/branch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSharedPref {
  final SharedPreferences _prefs;

  AuthSharedPref(this._prefs);

  static const String tokenKey = 'authToken';
  static const String idKey = 'userId';
  static const String companyIdKey = 'companyId';
  static const String companyNameKey = 'companyName';
  static const String branchIdKey = 'branchId';
  static const String emailKey = 'email';
  static const String roleKey = 'role';
  static const String employeeNameKey = 'employeeName';
  static const String employeeRoleKey = 'employeeRole'; // New key for employeeRole
  static const String permissionsKey = 'permissions';
  static const String cashRegisterIdKey = 'cashRegisterId';
  static const String isLoggedInKey = 'isLoggedIn';
  static const String branchListKey = 'branchList';
  static const String mobilePermissionsKey = 'mobilePermissions';


  Future<void> saveLoginResponse(LoginResponse response) async {
    await _prefs.setBool(isLoggedInKey, true);
    await _prefs.setString(tokenKey, response.token);
    await _prefs.setInt(idKey, response.id);
    await _prefs.setInt(companyIdKey, response.companyId);
    await _prefs.setString(companyNameKey, response.companyName);
    await _prefs.setInt(branchIdKey, response.branchId);
    await _prefs.setString(emailKey, response.email ?? '');
    await _prefs.setString(roleKey, response.role ?? '');
    await _prefs.setString(employeeNameKey, response.employeeName);
    await _prefs.setString(employeeRoleKey, response.employeeRole);
    await _prefs.setStringList(permissionsKey, response.permissions);
    await _prefs.setString(
      mobilePermissionsKey, 
      json.encode(response.mobilePermissions.toJson()), // Save mobilePermissions as JSON string
    );
  }

  // Method to get mobilePermissions from SharedPreferences
  MobilePermissions? getMobilePermissions() {
    final String? mobilePermissionsJson = _prefs.getString(mobilePermissionsKey);
    if (mobilePermissionsJson != null) {
      return MobilePermissions.fromJson(json.decode(mobilePermissionsJson));
    }
    return null;
  }

  // Method to clear mobilePermissions from SharedPreferences
  Future<void> clearMobilePermissions() async {
    await _prefs.remove(mobilePermissionsKey);
  }

  Future<void> clearLoginResponse() async {
    await _prefs.setBool(isLoggedInKey, false);
    await _prefs.remove(tokenKey);
    await _prefs.remove(idKey);
    await _prefs.remove(companyIdKey);
    await _prefs.remove(companyNameKey);
    await _prefs.remove(branchIdKey);
    await _prefs.remove(emailKey);
    await _prefs.remove(roleKey);
    await _prefs.remove(employeeNameKey);
    await _prefs.remove(employeeRoleKey); // Clear employeeRole
    await _prefs.remove(permissionsKey);
    await _prefs.remove(mobilePermissionsKey);
  }

  Future<void> closeCashier() async {
    await _prefs.setBool(isLoggedInKey, false);
    await _prefs.remove(tokenKey);
    await _prefs.remove(idKey);
    await _prefs.remove(companyIdKey);
    await _prefs.remove(companyNameKey);
    await _prefs.remove(branchIdKey);
    await _prefs.remove(emailKey);
    await _prefs.remove(roleKey);
    await _prefs.remove(employeeNameKey);
    await _prefs.remove(employeeRoleKey); // Clear employeeRole
    await _prefs.remove(permissionsKey);
    await _prefs.remove(cashRegisterIdKey); // Clear cash register ID
    await _prefs.remove(mobilePermissionsKey); // Clear cash register ID
  }

  Future<void> saveBranchList(List<Branch> branches) async {
    final List<String> branchListJson = branches.map((branch) => json.encode(branch.toJson())).toList();
    await _prefs.setStringList(branchListKey, branchListJson);
  }

  // Method to get branch list from SharedPreferences
  List<Branch> getBranchList() {
    final List<String>? branchListJson = _prefs.getStringList(branchListKey);
    if (branchListJson != null) {
      return branchListJson.map((branchJson) => Branch.fromJson(json.decode(branchJson))).toList();
    }
    return [];
  }

  // Method to clear branch list from SharedPreferences
  Future<void> clearBranchList() async {
    await _prefs.remove(branchListKey);
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

  String? getCompanyName() {
    return _prefs.getString(companyNameKey);
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

  String? getEmployeeName() {
    return _prefs.getString(employeeNameKey);
  }

  // Method to get employeeRole
  String? getEmployeeRole() {
    return _prefs.getString(employeeRoleKey);
  }

  List<String>? getPermissions() {
    return _prefs.getStringList(permissionsKey);
  }

  // Method to cache cash_register_id
  Future<void> cacheCashRegisterId(int cashRegisterId) async {
    await _prefs.setInt(cashRegisterIdKey, cashRegisterId);
  }

  // Method to get cached cash_register_id
  int? getCachedCashRegisterId() {
    return _prefs.getInt(cashRegisterIdKey);
  }

  // Method to clear cached cash_register_id
  Future<void> clearCashRegisterIdCache() async {
    await _prefs.remove(cashRegisterIdKey);
  }

  // New method to save branchId
  Future<void> saveBranchId(int branchId) async {
    await _prefs.setInt(branchIdKey, branchId);
  }
}
