class EmployeePerformance {
  final int employeePerformanceId;
  final String employeeType;
  final String employeeName;
  final String role;
  final int? performanceScore; // Nullable because some employees may not have a score

  EmployeePerformance({
    required this.employeePerformanceId,
    required this.employeeType,
    required this.employeeName,
    required this.role,
    required this.performanceScore,
  });

  factory EmployeePerformance.fromJson(Map<String, dynamic> json) {
    return EmployeePerformance(
      employeePerformanceId: json['employee_performance_id'],
      employeeType: json['employee_type'],
      employeeName: json['employee_name'],
      role: json['role'],
      performanceScore: json['performance_score'] != null ? json['performance_score'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_performance_id': employeePerformanceId,
      'employee_type': employeeType,
      'employee_name': employeeName,
      'role': role,
      'performance_score': performanceScore,
    };
  }
}
