class EmployeeSOPResponse {
  final String sopContent;

  EmployeeSOPResponse({required this.sopContent});

  factory EmployeeSOPResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeSOPResponse(
      sopContent: json['sop_content'],
    );
  }
}
