class AddRawMaterialStockRequest {
  final int branchId;
  final int materialId;
  final int quantity;
  final int unitId;
  final double price;
  final int vendorId;
  final int warehouseId;
  final int orderStatusId;
  final String purchaseDate;
  final String expiryDate;

  AddRawMaterialStockRequest({
    required this.branchId,
    required this.materialId,
    required this.quantity,
    required this.unitId,
    required this.price,
    required this.vendorId,
    required this.warehouseId,
    required this.orderStatusId,
    required this.purchaseDate,
    required this.expiryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'material_id': materialId,
      'quantity': quantity,
      'unit_id': unitId,
      'price': price,
      'vendor_id': vendorId,
      'warehouse_id': warehouseId,
      'order_status_id': orderStatusId,
      'purchase_date': purchaseDate,
      'expiry_date': expiryDate,
    };
  }
}

class AddRawMaterialStockResponse {
  final String message;

  AddRawMaterialStockResponse({required this.message});

  factory AddRawMaterialStockResponse.fromJson(Map<String, dynamic> json) {
    return AddRawMaterialStockResponse(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

