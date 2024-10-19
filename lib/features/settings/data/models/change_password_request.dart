class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;
  final String passwordConfirmation;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'password': newPassword,
      'password_confirmation': passwordConfirmation,
    };
  }
}

class ChangePasswordResponse {
  final String message;
  final String status;

  ChangePasswordResponse({required this.message, required this.status});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      message: json['message'],
      status: json['status'],
    );
  }
}
