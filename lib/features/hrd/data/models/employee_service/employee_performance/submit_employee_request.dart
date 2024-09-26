class SubmitEmployeePerformanceRequest {
  final int employeePerformanceId;
  final PerformanceScore attendance;
  final PerformanceScore collaboration;
  final PerformanceScore workInnovation;

  SubmitEmployeePerformanceRequest({
    required this.employeePerformanceId,
    required this.attendance,
    required this.collaboration,
    required this.workInnovation,
  });

  Map<String, dynamic> toJson() {
    return {
      'employee_performance_id': employeePerformanceId,
      'attendance': attendance.toJson(),
      'collaboration': collaboration.toJson(),
      'work_innovation': workInnovation.toJson(),
    };
  }
}

class PerformanceScore {
  final int score;
  final String remarks;

  PerformanceScore({
    required this.score,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'remarks': remarks,
    };
  }
}
