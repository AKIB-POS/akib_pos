import 'dart:convert';

import 'package:akib_pos/features/hrd/data/models/subordinate_employee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HRDSharedPref {
  final SharedPreferences sharedPreferences;

  HRDSharedPref(this.sharedPreferences);

  static const String _employeeListKey = 'subordinate_employee_list';

  Future<void> saveEmployeeList(List<SubordinateEmployeeModel> employees) async {
    List<String> employeeJsonList =
        employees.map((employee) => json.encode(employee.toJson())).toList();
    await sharedPreferences.setStringList(_employeeListKey, employeeJsonList);
  }

  List<SubordinateEmployeeModel> getEmployeeList() {
    List<String>? employeeJsonList =
        sharedPreferences.getStringList(_employeeListKey);
    if (employeeJsonList != null) {
      return employeeJsonList
          .map((employeeJson) => SubordinateEmployeeModel.fromJson(json.decode(employeeJson)))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> clearEmployeeList() async {
    await sharedPreferences.remove(_employeeListKey);
  }
}
