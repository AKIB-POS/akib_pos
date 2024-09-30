class SubmitPermissionRequest {
  final int permissionTypeId;
  final String workDate;
  final String timeIn;
  final String description;
  final String? attachmentPath;

  SubmitPermissionRequest({
    required this.permissionTypeId,
    required this.workDate,
    required this.timeIn,
    required this.description,
    this.attachmentPath,
  });

  // Konversi data ke format form-data
  Map<String, String> toFormData() {
    return {
      'permission_type_id': permissionTypeId.toString(),
      'work_date': workDate,
      'time_in': timeIn,
      'description': description,
      if (attachmentPath != null) 'attachment': attachmentPath!,  // Path file attachment
    };
  }
}
