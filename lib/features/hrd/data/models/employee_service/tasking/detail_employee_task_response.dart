class DetailEmployeeTaskResponse {
  final String taskingSubmissionDatetime;
  final String taskingName;
  final String taskingEndDatetime;
  final String taskingAssignerName;
  final String taskingAssignerRole;

  DetailEmployeeTaskResponse({
    required this.taskingSubmissionDatetime,
    required this.taskingName,
    required this.taskingEndDatetime,
    required this.taskingAssignerName,
    required this.taskingAssignerRole,
  });

  factory DetailEmployeeTaskResponse.fromJson(Map<String, dynamic> json) {
    return DetailEmployeeTaskResponse(
      taskingSubmissionDatetime: json['tasking_submission_datetime'] ?? '',
      taskingName: json['tasking_name'] ?? '',
      taskingEndDatetime: json['tasking_end_datetime'] ?? '',
      taskingAssignerName: json['tasking_assigner_name'] ?? '',
      taskingAssignerRole: json['tasking_assigner_role'] ?? '',
    );
  }
}
