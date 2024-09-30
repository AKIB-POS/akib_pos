class LeaveRequest {
  final int leaveType;
  final int totalDays;
  final String startDate;
  final String endDate;
  final String description;
  final String? attachmentPath;  // Path ke file attachment (image)

  LeaveRequest({
    required this.leaveType,
    required this.totalDays,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.attachmentPath,
  });

  // Pastikan semua nilai dikonversi menjadi String
  Map<String, String> toFormData() {
    return {
      'leave_type_id': leaveType.toString(),
      'total_days': totalDays.toString(),
      'start_date': startDate,
      'end_date': endDate,
      'description': description,
      if (attachmentPath != null) 'attachment': attachmentPath!, // Konversi ke String
    };
  }
}