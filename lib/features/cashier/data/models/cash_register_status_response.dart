class CashRegisterStatusResponse {
  final String message;
  final String status;

  CashRegisterStatusResponse({
    required this.message,
    required this.status,
  });

  factory CashRegisterStatusResponse.fromJson(Map<String, dynamic> json) {
    return CashRegisterStatusResponse(
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
    };
  }
}
