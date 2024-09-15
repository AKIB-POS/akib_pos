class AttendanceSummary {
  final String? clockInTime;
  final String? clockOutTime;
  final int leaveBalance;
  final int permissionBalance;
  final int? requestBalance;

  AttendanceSummary({
    this.clockInTime,
    this.clockOutTime,
    required this.leaveBalance,
    required this.permissionBalance,
    this.requestBalance,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      clockInTime: json['clock_in_time'],
      clockOutTime: json['clock_out_time'],
      leaveBalance: json['leave_balance'],
      permissionBalance: json['permission_balance'],
      requestBalance: json['request_balance'],
    );
  }
}

class AttendanceSummaryResponse {
  final String message;
  final AttendanceSummary data;

  AttendanceSummaryResponse({required this.message, required this.data});

  factory AttendanceSummaryResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryResponse(
      message: json['message'],
      data: AttendanceSummary.fromJson(json['data']),
    );
  }
}
