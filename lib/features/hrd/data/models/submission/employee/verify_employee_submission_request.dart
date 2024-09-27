class VerifyEmployeeSubmissionRequest {
  final int employeeSubmissionId;
  final String status;
  final String? reason; // Optional reason field

  VerifyEmployeeSubmissionRequest({
    required this.employeeSubmissionId,
    required this.status,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'employee_submission_id': employeeSubmissionId,
      'status': status,
      'reason': reason, // Include reason if provided
    };
  }
}
