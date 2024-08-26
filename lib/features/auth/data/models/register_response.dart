class RegisterResponse{
  final String message;
  final String? error;

  RegisterResponse({required this.message, this.error});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'],
      error: json['error'] ?? "",
    );
  }
}