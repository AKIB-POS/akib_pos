class OvertimeRequest {
  final String requestDate;
  final String overtimeDescription;
  final String startDatetime;
  final String endDatetime;
  final String approverName;

  OvertimeRequest({
    required this.requestDate,
    required this.overtimeDescription,
    required this.startDatetime,
    required this.endDatetime,
    required this.approverName,
  });

  factory OvertimeRequest.fromJson(Map<String, dynamic> json) {
    return OvertimeRequest(
      requestDate: json['request_date'],
      overtimeDescription: json['overtime_description'],
      startDatetime: json['start_datetime'],
      endDatetime: json['end_datetime'],
      approverName: json['approver_name'],
    );
  }
}

class OvertimeRequestResponse {
  final List<OvertimeRequest> data;

  OvertimeRequestResponse({required this.data});

  factory OvertimeRequestResponse.fromJson(Map<String, dynamic> json) {
    return OvertimeRequestResponse(
      data: (json['data'] as List)
          .map((item) => OvertimeRequest.fromJson(item))
          .toList(),
    );
  }
}