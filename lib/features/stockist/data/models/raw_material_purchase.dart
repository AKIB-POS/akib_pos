class RawMaterialPurchase {
  final int materialId;
  final String materialName;
  final String quantity;

  RawMaterialPurchase({
    required this.materialId,
    required this.materialName,
    required this.quantity,
  });

  // Factory constructor for creating an instance from JSON
  factory RawMaterialPurchase.fromJson(Map<String, dynamic> json) {
    return RawMaterialPurchase(
      materialId: json['material_id'] ?? 0,
      materialName: json['material_name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'material_id': materialId,
      'material_name': materialName,
      'quantity': quantity,
    };
  }
}

class RawMaterialPurchasesResponse {
  final List<RawMaterialPurchase> purchases;

  RawMaterialPurchasesResponse({required this.purchases});

  // Factory constructor for creating an instance from JSON
  factory RawMaterialPurchasesResponse.fromJson(Map<String, dynamic> json) {
    var purchases = (json['data'] as List)
        .map((purchase) => RawMaterialPurchase.fromJson(purchase))
        .toList();
    return RawMaterialPurchasesResponse(purchases: purchases);
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': purchases.map((purchase) => purchase.toJson()).toList(),
    };
  }
}
