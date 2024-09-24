class VerifyEmployeeSubmissionResponse {
  final String message;
  final String status;

  VerifyEmployeeSubmissionResponse({
    required this.message,
    required this.status,
  });

  factory VerifyEmployeeSubmissionResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmployeeSubmissionResponse(
      message: json['message'],
      status: json['status'],
    );
  }
}
