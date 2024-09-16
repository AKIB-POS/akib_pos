import 'dart:convert';

import 'dart:convert';

class AttendanceSummaryResponse {
  final String message;
  final AttendanceSummaryData data;

  AttendanceSummaryResponse({
    required this.message,
    required this.data,
  });

  factory AttendanceSummaryResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryResponse(
      message: json['message'] as String,
      data: AttendanceSummaryData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AttendanceSummaryData {
  final String? clockInTime;
  final String? clockOutTime;
  final String expectedClockInTime;
  final String expectedClockOutTime;
  final int? leaveBalance;
  final int? permissionBalance;
  final int? requestBalance;

  AttendanceSummaryData({
    this.clockInTime,
    this.clockOutTime,
    required this.expectedClockInTime,
    required this.expectedClockOutTime,
    this.leaveBalance,
    this.permissionBalance,
    this.requestBalance,
  });

  factory AttendanceSummaryData.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryData(
      clockInTime: json['clock_in_time'],
      clockOutTime: json['clock_out_time'],
      expectedClockInTime: json['expected_clock_in_time'],
      expectedClockOutTime: json['expected_clock_out_time'],
      leaveBalance: json['leave_balance'],
      permissionBalance: json['permission_balance'],
      requestBalance: json['request_balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clock_in_time': clockInTime,
      'clock_out_time': clockOutTime,
      'expected_clock_in_time': expectedClockInTime,
      'expected_clock_out_time': expectedClockOutTime,
      'leave_balance': leaveBalance,
      'permission_balance': permissionBalance,
      'request_balance': requestBalance,
    };
  }
}
