import 'dart:convert';

import 'package:akib_pos/features/accounting/data/models/transaction_report/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeSharedPref {
  final SharedPreferences sharedPreferences;

  EmployeeSharedPref(this.sharedPreferences);

  static const String _employeeListKey = 'employee_list';

  Future<void> saveEmployeeList(List<EmployeeModel> employees) async {
    List<String> employeeJsonList =
        employees.map((employee) => json.encode(employee.toJson())).toList();
    await sharedPreferences.setStringList(_employeeListKey, employeeJsonList);
  }

  List<EmployeeModel> getEmployeeList() {
    List<String>? employeeJsonList =
        sharedPreferences.getStringList(_employeeListKey);
    if (employeeJsonList != null) {
      return employeeJsonList
          .map((employeeJson) => EmployeeModel.fromJson(json.decode(employeeJson)))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> clearEmployeeList() async {
    await sharedPreferences.remove(_employeeListKey);
  }
}
