class Purchase {
  final int purchaseId;
  final String purchaseType;
  final String materialName;
  final String quantity;

  Purchase({
    required this.purchaseId,
    required this.purchaseType,
    required this.materialName,
    required this.quantity,
  });

  // Factory constructor for creating an instance from JSON
  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      purchaseId: json['material_id'] ?? 0,
      purchaseType: json['purchase_type'] ?? '',
      materialName: json['material_name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'purchase_id': purchaseId,
      'purchase_type': purchaseType,
      'material_name': materialName,
      'quantity': quantity,
    };
  }
}

class PurchasesListResponse {
  final List<Purchase> purchases;

  PurchasesListResponse({required this.purchases});

  // Factory constructor for creating an instance from JSON
  factory PurchasesListResponse.fromJson(Map<String, dynamic> json) {
    var purchases = (json['data'] as List)
        .map((purchase) => Purchase.fromJson(purchase))
        .toList();
    return PurchasesListResponse(purchases: purchases);
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': purchases.map((purchase) => purchase.toJson()).toList(),
    };
  }
}
