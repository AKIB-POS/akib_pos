class AttendanceHistoryItem {
  final String date;
  final String clockInTime;
  final String clockInStatus;
  final String clockOutTime;
  final String clockOutStatus;

  AttendanceHistoryItem({
    required this.date,
    required this.clockInTime,
    required this.clockInStatus,
    required this.clockOutTime,
    required this.clockOutStatus,
  });

  factory AttendanceHistoryItem.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryItem(
      date: json['date'],
      clockInTime: json['clock_in_time'],
      clockInStatus: json['clock_in_status'],
      clockOutTime: json['clock_out_time'],
      clockOutStatus: json['clock_out_status'],
    );
  }
}

class AttendanceHistoryResponse {
  final String message;
  final List<AttendanceHistoryItem> data;

  AttendanceHistoryResponse({required this.message, required this.data});

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryResponse(
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => AttendanceHistoryItem.fromJson(item))
          .toList(),
    );
  }
}
