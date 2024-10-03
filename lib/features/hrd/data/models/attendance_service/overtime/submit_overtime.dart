class SubmitOvertimeRequest {
  final String workDate;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String description;
  final int overtimeTypeId;
  final String? attachmentPath; // Path untuk file attachment

  SubmitOvertimeRequest({
    required this.workDate,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.description,
    required this.overtimeTypeId,
    this.attachmentPath,
  });

  // Konversi data ke form-data
  Map<String, String> toFormData() {
    return {
      'work_date': workDate,
      'start_date': startDate,
      'start_time': startTime,
      'end_date': endDate,
      'end_time': endTime,
      'description': description,
      'overtime_type_id': overtimeTypeId.toString(),
      if (attachmentPath != null) 'attachment': attachmentPath!,
    };
  }
}
