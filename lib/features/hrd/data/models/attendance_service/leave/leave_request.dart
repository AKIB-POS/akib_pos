class LeaveRequest {
  final int leaveType;
  final String startDate;
  final String endDate;
  final String description;
  final String? attachmentPath;  // Optional path for an attachment file (image)

  LeaveRequest({
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.attachmentPath,
  });

  // Convert all values to String for form data submission
  Map<String, String> toFormData() {
    return {
      'leave_type_id': leaveType.toString(),
      'start_date': startDate,
      'end_date': endDate,
      'description': description,
      if (attachmentPath != null) 'attachment': attachmentPath!,  // Ensure attachment is included if present
    };
  }
}
