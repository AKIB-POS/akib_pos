// OvertimeHistoryData.dart
class OvertimeHistoryData {
  final String overtimeDescription;
  final String startDatetime;
  final String endDatetime;
  final String status;

  OvertimeHistoryData({
    required this.overtimeDescription,
    required this.startDatetime,
    required this.endDatetime,
    required this.status,
  });

  factory OvertimeHistoryData.fromJson(Map<String, dynamic> json) {
    return OvertimeHistoryData(
      overtimeDescription: json['overtime_description'],
      startDatetime: json['start_datetime'],
      endDatetime: json['end_datetime'],
      status: json['status'],
    );
  }
}

// OvertimeHistoryResponse.dart
class OvertimeHistoryResponse {
  final List<OvertimeHistoryData> data;

  OvertimeHistoryResponse({required this.data});

  factory OvertimeHistoryResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<OvertimeHistoryData> data = dataList.map((i) => OvertimeHistoryData.fromJson(i)).toList();
    return OvertimeHistoryResponse(data: data);
  }
}
