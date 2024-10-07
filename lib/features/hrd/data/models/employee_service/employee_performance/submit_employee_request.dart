class SubmitEmployeePerformanceRequest {
  final int employeeId;
  final int month;
  final int year;
  final Map<int, PerformanceScore> performanceMetrics;

  SubmitEmployeePerformanceRequest({
    required this.employeeId,
    required this.month,
    required this.year,
    required this.performanceMetrics,
  });

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'month': month,
      'year': year,
      'performance_metrics': performanceMetrics.map((key, score) => MapEntry(key.toString(), score.toJson())),
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
