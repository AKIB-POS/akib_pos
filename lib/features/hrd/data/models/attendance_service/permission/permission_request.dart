class PermissionRequest {
  final String requestDate;
  final String permissionType;
  final String startDate;
  final String time;
  final String approverName;

  PermissionRequest({
    required this.requestDate,
    required this.permissionType,
    required this.startDate,
    required this.time,
    required this.approverName,
  });

  factory PermissionRequest.fromJson(Map<String, dynamic> json) {
    return PermissionRequest(
      requestDate: json['request_date'],
      permissionType: json['permission_type'],
      startDate: json['start_date'],
      time: json['time'],
      approverName: json['approver_name'],
    );
  }
}

class PermissionRequestResponse {
  final List<PermissionRequest> data;

  PermissionRequestResponse({required this.data});

  factory PermissionRequestResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<PermissionRequest> dataList =
        list.map((i) => PermissionRequest.fromJson(i)).toList();

    return PermissionRequestResponse(data: dataList);
  }
}
