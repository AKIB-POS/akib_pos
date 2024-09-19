class HRDSummaryResponse {
  final String? clockInTime;
  final String? clockOutTime;
  final String? expectedClockInTime;
  final String? expectedClockOutTime;
  final int leaveBalance;
  final int totalAbsences;
  final int totalCandidateVerifications;
  final int totalSubmissionVerifications;

  HRDSummaryResponse({
    this.clockInTime,
    this.clockOutTime,
    this.expectedClockInTime,
    this.expectedClockOutTime,
    required this.leaveBalance,
    required this.totalAbsences,
    required this.totalCandidateVerifications,
    required this.totalSubmissionVerifications,
  });

  factory HRDSummaryResponse.fromJson(Map<String, dynamic> json) {
    return HRDSummaryResponse(
      clockInTime: json['clock_in_time'],
      clockOutTime: json['clock_out_time'],
      expectedClockInTime: json['expected_clock_in_time'],
      expectedClockOutTime: json['expected_clock_out_time'],
      leaveBalance: json['leave_balance'],
      totalAbsences: json['total_absences'],
      totalCandidateVerifications: json['total_candidate_verifications'],
      totalSubmissionVerifications: json['total_submission_verifications'],
    );
  }
}
