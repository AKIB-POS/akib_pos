class HRDSummaryResponse {
  final String? clockInTime;
  final String? clockOutTime;
  final String? expectedClockInTime;
  final String? expectedClockOutTime;
  final int? leaveBalance;
  final int? totalAbsences;
  final int? totalCandidateVerifications;
  final int? totalSubmissionVerifications;
  final int? totalEmployee;

  HRDSummaryResponse({
    this.clockInTime,
    this.clockOutTime,
    this.expectedClockInTime,
    this.expectedClockOutTime,
    this.leaveBalance,
    this.totalAbsences,
    this.totalCandidateVerifications,
    this.totalSubmissionVerifications,
    this.totalEmployee,
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
      totalEmployee: json['total_employee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clock_in_time': clockInTime,
      'clock_out_time': clockOutTime,
      'expected_clock_in_time': expectedClockInTime,
      'expected_clock_out_time': expectedClockOutTime,
      'leave_balance': leaveBalance,
      'total_absences': totalAbsences,
      'total_candidate_verifications': totalCandidateVerifications,
      'total_submission_verifications': totalSubmissionVerifications,
      'total_employee': totalEmployee,
    };
  }
}
