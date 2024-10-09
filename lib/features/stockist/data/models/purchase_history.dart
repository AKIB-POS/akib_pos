class PurchaseHistory {
  final String purchaseName;
  final String purchaseDate;
  final String quantity;
  final String vendor;
  final String expirationDate;
  final double purchasePrice;
  final String orderStatus;

  PurchaseHistory({
    required this.purchaseName,
    required this.purchaseDate,
    required this.quantity,
    required this.vendor,
    required this.expirationDate,
    required this.purchasePrice,
    required this.orderStatus,
  });

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) {
    return PurchaseHistory(
      purchaseName: json['purchase_name'] ?? '',
      purchaseDate: json['purchase_date'] ?? '',
      quantity: json['quantity'] ?? '',
      vendor: json['vendor'] ?? '',
      expirationDate: json['expiration_date'] ?? '',
      purchasePrice: (json['purchase_price'] as num?)?.toDouble() ?? 0.0,
      orderStatus: json['order_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchase_name': purchaseName,
      'purchase_date': purchaseDate,
      'quantity': quantity,
      'vendor': vendor,
      'expiration_date': expirationDate,
      'purchase_price': purchasePrice,
      'order_status': orderStatus,
    };
  }
}

class PurchaseHistoryResponse {
  final List<PurchaseHistory> purchaseHistories;

  PurchaseHistoryResponse({required this.purchaseHistories});

  factory PurchaseHistoryResponse.fromJson(Map<String, dynamic> json) {
    var historyList = (json['data'] as List)
        .map((history) => PurchaseHistory.fromJson(history))
        .toList();
    return PurchaseHistoryResponse(purchaseHistories: historyList);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': purchaseHistories.map((history) => history.toJson()).toList(),
    };
  }
}
