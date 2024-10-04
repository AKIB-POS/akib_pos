class LeaveRequestResponse {
  final String message;
  final List<LeaveRequestData> data;

  LeaveRequestResponse({required this.message, required this.data});

  factory LeaveRequestResponse.fromJson(Map<String, dynamic> json) {
    return LeaveRequestResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((item) => LeaveRequestData.fromJson(item))
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

class LeaveRequestData {
  final String requestDate;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String? approverName;

  LeaveRequestData({
    required this.requestDate,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    this.approverName,
  });

  factory LeaveRequestData.fromJson(Map<String, dynamic> json) {
    return LeaveRequestData(
      requestDate: json['request_date'] ?? '',
      leaveType: json['leave_type'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      approverName: json['approver_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_date': requestDate,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'approver_name': approverName,
    };
  }
}
