class CandidateSubmission {
  final int candidateSubmissionId;
  final String candidateName;
  final String submissionDate;
  final String submissionType;
  final String? approverName;
  final String approvalStatus;

  CandidateSubmission({
    required this.candidateSubmissionId,
    required this.candidateName,
    required this.submissionDate,
    required this.submissionType,
    required this.approverName,
    required this.approvalStatus,
  });

  factory CandidateSubmission.fromJson(Map<String, dynamic> json) {
    return CandidateSubmission(
      candidateSubmissionId: json['candidate_submission_id'],
      candidateName: json['candidate_name'],
      submissionDate: json['submission_date'],
      submissionType: json['submission_type'],
      approverName: json['approver_name'] ,
      approvalStatus: json['approval_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate_submission_id': candidateSubmissionId,
      'candidate_name': candidateName,
      'submission_date': submissionDate,
      'submission_type': submissionType,
      'approver_name': approverName,
      'approval_status': approvalStatus,
    };
  }
}
