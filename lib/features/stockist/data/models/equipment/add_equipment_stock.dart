class AddEquipmentStockRequest {
  final int branchId;
  final int equipmentId;
  final int quantity;
  final String unitName;
  final double price;
  final int vendorId;
  final int warehouseId;
  final int orderStatusId;
  final String purchaseDate;

  AddEquipmentStockRequest({
    required this.branchId,
    required this.equipmentId,
    required this.quantity,
    required this.unitName,
    required this.price,
    required this.vendorId,
    required this.warehouseId,
    required this.orderStatusId,
    required this.purchaseDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'equipment_id': equipmentId,
      'quantity': quantity,
      'unit_name': unitName,
      'price': price,
      'vendor_id': vendorId,
      'warehouse_id': warehouseId,
      'order_status_id': orderStatusId,
      'purchase_date': purchaseDate,
    };
  }
}

class AddEquipmentStockResponse {
  final String message;

  AddEquipmentStockResponse({required this.message});

  factory AddEquipmentStockResponse.fromJson(Map<String, dynamic> json) {
    return AddEquipmentStockResponse(
      message: json['message'] ?? '',
    );
  }
}
