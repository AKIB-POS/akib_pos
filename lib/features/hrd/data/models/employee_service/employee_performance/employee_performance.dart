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
    this.performanceScore,  // Nullable field
  });

  factory EmployeePerformance.fromJson(Map<String, dynamic> json) {
    return EmployeePerformance(
      employeePerformanceId: (json['employee_id'] as num?)?.toInt() ?? 0, // Safe casting and default
      employeeType: json['employee_type'] ?? '', // Default to empty string if missing
      employeeName: json['employee_name'] ?? '', // Default to empty string if missing
      role: json['role'] ?? '', // Default to empty string if missing
      performanceScore: json['performance_score'] != null ? json['performance_score'] as int : null, // Nullable
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
