class EquipmentPurchase {
  final int equipmentId;
  final String equipmentName;
  final String quantity;

  EquipmentPurchase({
    required this.equipmentId,
    required this.equipmentName,
    required this.quantity,
  });

  // Factory constructor for creating an instance from JSON
  factory EquipmentPurchase.fromJson(Map<String, dynamic> json) {
    return EquipmentPurchase(
      equipmentId: json['equipment_id'],
      equipmentName: json['equipment_name'],
      quantity: json['quantity'],
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'equipment_id': equipmentId,
      'equipment_name': equipmentName,
      'quantity': quantity,
    };
  }
}

class EquipmentPurchaseResponse {
  final List<EquipmentPurchase> equipmentPurchases;

  EquipmentPurchaseResponse({required this.equipmentPurchases});

  // Factory constructor for creating an instance from JSON
  factory EquipmentPurchaseResponse.fromJson(Map<String, dynamic> json) {
    var purchases = (json['data'] as List)
        .map((purchase) => EquipmentPurchase.fromJson(purchase))
        .toList();
    return EquipmentPurchaseResponse(equipmentPurchases: purchases);
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': equipmentPurchases.map((purchase) => purchase.toJson()).toList(),
    };
  }
}
