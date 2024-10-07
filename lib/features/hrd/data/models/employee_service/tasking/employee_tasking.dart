class EmployeeTask {
  final int taskingId;
  final String taskingName;
  final String taskSubmissionDate;
  final String taskEndDatetime;

  EmployeeTask({
    required this.taskingId,
    required this.taskingName,
    required this.taskSubmissionDate,
    required this.taskEndDatetime,
  });

  factory EmployeeTask.fromJson(Map<String, dynamic> json) {
    return EmployeeTask(
      taskingId: json['tasking_id'] ?? 0,
      taskingName: json['tasking_name'] ?? '',
      taskSubmissionDate: json['task_submission_date'] ?? '',
      taskEndDatetime: json['task_end_datetime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tasking_id': taskingId,
      'tasking_name': taskingName,
      'task_submission_date': taskSubmissionDate,
      'task_end_datetime': taskEndDatetime,
    };
  }
}
