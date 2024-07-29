class AuthResponse {
  final String message;
  final String accessToken;
  final String tokenType;

  AuthResponse({required this.message, required this.accessToken, required this.tokenType});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'],
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}