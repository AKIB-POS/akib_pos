class OpenCashierRequest {
  final String idUser;
  final String datetime;
  final double jumlah;
  final String branchId;
  final String status;

  OpenCashierRequest({
    required this.idUser,
    required this.datetime,
    required this.jumlah,
    required this.branchId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_user": idUser,
      "datetime": datetime,
      "amount": jumlah,
      "branch_id": branchId,
      "status": status,
    };
  }
}

class OpenCashierResponse {
  final String message;
  final int cashRegisterId;

  OpenCashierResponse({
    required this.message,
    required this.cashRegisterId,
  });

  factory OpenCashierResponse.fromJson(Map<String, dynamic> json) {
    return OpenCashierResponse(
      message: json['message'] ?? '', // Default to empty string if null
      cashRegisterId: (json['cash_register_id'] as num?)?.toInt() ?? 0, // Safely cast to int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'cash_register_id': cashRegisterId,
    };
  }
}

class PostCloseCashierResponse {
  final String message;

  PostCloseCashierResponse({
    required this.message,
  });

  factory PostCloseCashierResponse.fromJson(Map<String, dynamic> json) {
    return PostCloseCashierResponse(
      message: json['message'] ?? '', // Default to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
