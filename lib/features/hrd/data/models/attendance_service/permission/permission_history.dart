class PermissionHistoryResponse {
  final String message;
  final List<PermissionHistoryData> data;

  PermissionHistoryResponse({required this.message, required this.data});

  factory PermissionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PermissionHistoryResponse(
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => PermissionHistoryData.fromJson(item))
          .toList(),
    );
  }
}

class PermissionHistoryData {
  final String permissionType;
  final String startDate;
  final String time;
  final String status;

  PermissionHistoryData({
    required this.permissionType,
    required this.startDate,
    required this.time,
    required this.status,
  });

  factory PermissionHistoryData.fromJson(Map<String, dynamic> json) {
    return PermissionHistoryData(
      permissionType: json['permission_type'],
      startDate: json['start_date'],
      time: json['time'],
      status: json['status'],
    );
  }
}