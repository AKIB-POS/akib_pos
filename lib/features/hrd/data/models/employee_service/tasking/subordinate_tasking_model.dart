class SubordinateTaskModel {
  final int taskingId;
  final String taskingEmployeeName;
  final String taskingName;
  final String taskSubmissionDate;
  final String taskEndDatetime;
  final String taskStatus;

  SubordinateTaskModel({
    required this.taskingId,
    required this.taskingEmployeeName,
    required this.taskingName,
    required this.taskSubmissionDate,
    required this.taskEndDatetime,
    required this.taskStatus,
  });

  // Factory constructor untuk membuat instance dari JSON
  factory SubordinateTaskModel.fromJson(Map<String, dynamic> json) {
    return SubordinateTaskModel(
      taskingId: json['tasking_id'] ?? 0,
      taskingEmployeeName: json['tasking_employee_name'] ?? '',
      taskingName: json['tasking_name'] ?? '',
      taskSubmissionDate: json['task_submission_date'] ?? '',
      taskEndDatetime: json['task_end_datetime'] ?? '',
      taskStatus: json['task_status'] ?? '',
    );
  }

  // Method untuk mengkonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'tasking_id': taskingId,
      'tasking_employee_name': taskingEmployeeName,
      'tasking_name': taskingName,
      'task_submission_date': taskSubmissionDate,
      'task_end_datetime': taskEndDatetime,
      'task_status': taskStatus,
    };
  }
}
