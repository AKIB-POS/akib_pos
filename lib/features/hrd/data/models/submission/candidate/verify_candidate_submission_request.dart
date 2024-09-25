class VerifyCandidateSubmissionRequest {
  final int candidateSubmissionId;
  final String status;

  VerifyCandidateSubmissionRequest({
    required this.candidateSubmissionId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'candidate_submission_id': candidateSubmissionId,
      'status': status,
    };
  }
}
