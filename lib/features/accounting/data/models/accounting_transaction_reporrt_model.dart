class AccountingTransactionReportModel {
  final String transactionCode;
  final String? customerName;
  final double price;
  final double? discount;
  final String orderType;
  final String paymentType;

  AccountingTransactionReportModel({
    required this.transactionCode,
    this.customerName,
    required this.price,
    this.discount,
    required this.orderType,
    required this.paymentType,
  });

  factory AccountingTransactionReportModel.fromJson(Map<String, dynamic> json) {
    return AccountingTransactionReportModel(
      transactionCode: json['transaction_code'] ?? '',
      customerName: json['customer_name'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble(),
      orderType: json['order_type'] ?? '',
      paymentType: json['payment_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_code': transactionCode,
      'customer_name': customerName,
      'price': price,
      'discount': discount,
      'order_type': orderType,
      'payment_type': paymentType,
    };
  }
}

class AccountingTransactionListResponse {
  final String message;
  final List<AccountingTransactionReportModel> data;

  AccountingTransactionListResponse({
    required this.message,
    required this.data,
  });

  factory AccountingTransactionListResponse.fromJson(Map<String, dynamic> json) {
    var transactions = (json['data'] as List?)
        ?.map((transaction) =>
            AccountingTransactionReportModel.fromJson(transaction))
        .toList() ?? [];

    return AccountingTransactionListResponse(
      message: json['message'] ?? '',
      data: transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
