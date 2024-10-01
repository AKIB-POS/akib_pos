class HRDAllEmployee {
  final int employeeId;
  final String employeeName;
  final String employeeType;
  final String? role;

  HRDAllEmployee({
    required this.employeeId,
    required this.employeeName,
    required this.employeeType,
    this.role,  // role is nullable, so it's optional
  });

  factory HRDAllEmployee.fromJson(Map<String, dynamic> json) {
    return HRDAllEmployee(
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,  // Safe casting with default value
      employeeName: json['employee_name'] ?? '',  // Default to empty string if null
      employeeType: json['employee_type'] ?? '',  // Default to empty string if null
      role: json['role'],  // role is nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'employee_name': employeeName,
      'employee_type': employeeType,
      'role': role,
    };
  }
}
