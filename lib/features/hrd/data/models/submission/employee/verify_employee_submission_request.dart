class VerifyEmployeeSubmissionRequest {
  final int employeeSubmissionId;
  final String status;
  final String? reason; // Optional reason field
  final String submissionType; // New field for submission type

  VerifyEmployeeSubmissionRequest({
    required this.employeeSubmissionId,
    required this.status,
    this.reason,
    required this.submissionType, // Make submissionType a required field
  });

  Map<String, dynamic> toJson() {
    return {
      'employee_submission_id': employeeSubmissionId,
      'status': status,
      'reason': reason, // Include reason if provided
      'submission_type': submissionType, // Include the new submission_type field
    };
  }
}
