class SubmitEmployeeTaskingRequest {
  final int taskingId;
  final String description;
  final String? attachmentPath; // Path to file attachment (optional)

  SubmitEmployeeTaskingRequest({
    required this.taskingId,
    required this.description,
    this.attachmentPath,
  });

  // Convert request to form-data
  Map<String, String> toFormData() {
    return {
      'tasking_id': taskingId.toString(),
      'description': description,
      if (attachmentPath != null) 'attachment': attachmentPath!,
    };
  }
}
