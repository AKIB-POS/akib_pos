class LeaveHistoryResponse {
  final String message;
  final List<LeaveHistoryData> data;

  LeaveHistoryResponse({required this.message, required this.data});

  factory LeaveHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryResponse(
      message: json['message'],
      data: List<LeaveHistoryData>.from(
        json['data'].map((item) => LeaveHistoryData.fromJson(item)),
      ),
    );
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
      leaveType: json['leave_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
    );
  }
}
