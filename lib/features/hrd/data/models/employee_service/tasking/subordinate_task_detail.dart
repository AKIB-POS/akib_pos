class SubordinateTaskDetail {
  final String submissionDatetime;
  final String taskName;
  final String endDatetime;
  final String description;
  final String? attachment;

  SubordinateTaskDetail({
    required this.submissionDatetime,
    required this.taskName,
    required this.endDatetime,
    required this.description,
    this.attachment,
  });

  factory SubordinateTaskDetail.fromJson(Map<String, dynamic> json) {
    return SubordinateTaskDetail(
      submissionDatetime: json['tasking_submission_datetime'] ?? '',
      taskName: json['tasking_name'] ?? '',
      endDatetime: json['tasking_end_datetime'] ?? '',
      description: json['tasking_description'] ?? '',
      attachment: json['tasking_attachment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tasking_submission_datetime': submissionDatetime,
      'tasking_name': taskName,
      'tasking_end_datetime': endDatetime,
      'tasking_description': description,
      'tasking_attachment': attachment,
    };
  }
}
