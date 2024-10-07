class VerifyEmployeeSubmissionResponse {
  final String message;

  VerifyEmployeeSubmissionResponse({
    required this.message,
  });

  factory VerifyEmployeeSubmissionResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmployeeSubmissionResponse(
      message: json['message'],
    );
  }
}
