class CandidateSubmission {
  final String submissionDate;
  final String submissionType;
  final String approverName;
  final String approvalStatus;

  CandidateSubmission({
    required this.submissionDate,
    required this.submissionType,
    required this.approverName,
    required this.approvalStatus,
  });

  factory CandidateSubmission.fromJson(Map<String, dynamic> json) {
    return CandidateSubmission(
      submissionDate: json['submission_date'],
      submissionType: json['submission_type'],
      approverName: json['approver_name'],
      approvalStatus: json['approval_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submission_date': submissionDate,
      'submission_type': submissionType,
      'approver_name': approverName,
      'approval_status': approvalStatus,
    };
  }
}
