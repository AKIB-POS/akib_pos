class LeaveRequestResponse {
  final String message;
  final List<LeaveRequestData> data;

  LeaveRequestResponse({required this.message, required this.data});

  factory LeaveRequestResponse.fromJson(Map<String, dynamic> json) {
    return LeaveRequestResponse(
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => LeaveRequestData.fromJson(item))
          .toList(),
    );
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
    required this.approverName,
  });

  factory LeaveRequestData.fromJson(Map<String, dynamic> json) {
    return LeaveRequestData(
      requestDate: json['request_date'],
      leaveType: json['leave_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      approverName: json['approver_name'],
    );
  }
}
