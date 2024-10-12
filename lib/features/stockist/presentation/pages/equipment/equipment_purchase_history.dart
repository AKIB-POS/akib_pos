class EquipmentPurchaseHistory {
  final String purchaseName;
  final String purchaseDate;
  final String quantity;
  final String vendor;
  final double purchasePrice;
  final String orderStatus;

  EquipmentPurchaseHistory({
    required this.purchaseName,
    required this.purchaseDate,
    required this.quantity,
    required this.vendor,
    required this.purchasePrice,
    required this.orderStatus,
  });

  // Factory constructor to create an instance from JSON
  factory EquipmentPurchaseHistory.fromJson(Map<String, dynamic> json) {
    return EquipmentPurchaseHistory(
      purchaseName: json['purchase_name'] ?? '',
      purchaseDate: json['purchase_date'] ?? '',
      quantity: json['quantity'] ?? '0',
      vendor: json['vendor'] ?? '',
      purchasePrice: (json['purchase_price'] as num?)?.toDouble() ?? 0.0,
      orderStatus: json['order_status'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'purchase_name': purchaseName,
      'purchase_date': purchaseDate,
      'quantity': quantity,
      'vendor': vendor,
      'purchase_price': purchasePrice,
      'order_status': orderStatus,
    };
  }
}

class EquipmentPurchaseHistoryResponse {
  final List<EquipmentPurchaseHistory> purchaseHistories;

  EquipmentPurchaseHistoryResponse({required this.purchaseHistories});

  // Factory constructor to create an instance from JSON
  factory EquipmentPurchaseHistoryResponse.fromJson(Map<String, dynamic> json) {
    var purchases = (json['data'] as List)
        .map((purchase) => EquipmentPurchaseHistory.fromJson(purchase))
        .toList();
    return EquipmentPurchaseHistoryResponse(purchaseHistories: purchases);
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': purchaseHistories.map((purchase) => purchase.toJson()).toList(),
    };
  }
}
