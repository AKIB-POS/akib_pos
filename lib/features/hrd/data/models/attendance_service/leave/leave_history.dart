class LeaveHistoryResponse {
  final String message;
  final List<LeaveHistoryData> data;

  LeaveHistoryResponse({required this.message, required this.data});

  factory LeaveHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((item) => LeaveHistoryData.fromJson(item))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class LeaveHistoryData {
  final String leaveType;
  final String startDate;
  final String endDate;
  final String status;

  LeaveHistoryData({
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory LeaveHistoryData.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryData(
      leaveType: json['leave_type'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
    };
  }
}
