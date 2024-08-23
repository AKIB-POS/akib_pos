class OpenCashierRequest {
  final String idUser;
  final String datetime;
  final double jumlah;
  final String branchId;

  OpenCashierRequest({
    required this.idUser,
    required this.datetime,
    required this.jumlah,
    required this.branchId,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_user": idUser,
      "datetime": datetime,
      "amount": jumlah,
      "branch_id": branchId,
    };
  }
}


class OpenCashierResponse {
  final String message;

  OpenCashierResponse({required this.message});

  factory OpenCashierResponse.fromJson(Map<String, dynamic> json) {
    return OpenCashierResponse(
      message: json['message'],
    );
  }
}