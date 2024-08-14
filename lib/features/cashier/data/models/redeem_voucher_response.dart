class RedeemVoucherResponse {
  final String status;
  final VoucherData? data;
  final String? message;

  RedeemVoucherResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory RedeemVoucherResponse.fromJson(Map<String, dynamic> json) {
    return RedeemVoucherResponse(
      status: json['status'],
      data: json['data'] != null ? VoucherData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class VoucherData {
  final int? id;
  final String? name;
  final String type;
  final double amount;

  VoucherData({
    this.id,
    this.name,
    required this.type,
    required this.amount,
  });

  factory VoucherData.fromJson(Map<String, dynamic> json) {
    return VoucherData(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      amount: json['amount'].toDouble(),
    );
  }
}
