class DashboardSummaryHrdResponse {
  final int totalEmployees;
  final int onTime;
  final int late;
  final int absent;

  DashboardSummaryHrdResponse({
    required this.totalEmployees,
    required this.onTime,
    required this.late,
    required this.absent,
  });

  factory DashboardSummaryHrdResponse.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryHrdResponse(
      totalEmployees: json['total_employees'] ?? 0,
      onTime: json['on_time'] ?? 0,
      late: json['late'] ?? 0,
      absent: json['absent'] ?? 0,
    );
  }
}
