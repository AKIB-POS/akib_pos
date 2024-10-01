class HRDAllEmployee {
  final int employeeId;
  final String employeeName;
  final String employeeType;
  final String? role;

  HRDAllEmployee({
    required this.employeeId,
    required this.employeeName,
    required this.employeeType,
    required this.role,
  });

  factory HRDAllEmployee.fromJson(Map<String, dynamic> json) {
    return HRDAllEmployee(
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      employeeType: json['employee_type'],
      role: json['role'] , 
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
