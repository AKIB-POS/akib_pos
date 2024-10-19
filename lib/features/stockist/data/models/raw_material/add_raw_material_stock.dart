class AddRawMaterialStockRequest {
  final int branchId;
  final int ingredientId;  // Ganti dari materialId ke ingredientId
  final String? itemName;  // Tambahkan itemName sebagai null
  final int quantity;
  final double price;
  final String purchaseDate;
  final String expiryDate;
  final int unitId;  // Ganti dari unitName ke unitId
  final int orderStatusId;
  final String itemType;  // Tambahkan itemType
  final int vendorId;
  final int warehouseId;

  AddRawMaterialStockRequest({
    required this.branchId,
    required this.ingredientId,
    this.itemName,  // Bisa null, sesuai request
    required this.quantity,
    required this.price,
    required this.purchaseDate,
    required this.expiryDate,
    required this.unitId,
    required this.orderStatusId,
    required this.itemType,  // Tambahkan ke request
    required this.vendorId,
    required this.warehouseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'ingredient_id': ingredientId,  // Ganti dari material_id ke ingredient_id
      'item_name': itemName,  // Akan selalu null
      'quantity': quantity,
      'price': price,
      'purchase_date': purchaseDate,
      'expiry_date': expiryDate,
      'unit_id': unitId,  // Ganti dari unit_name ke unit_id
      'order_status_id': orderStatusId,
      'item_type': itemType,  // Tambahkan item_type
      'vendor_id': vendorId,
      'warehouse_id': warehouseId,
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
