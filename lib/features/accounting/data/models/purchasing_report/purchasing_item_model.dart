class PurchaseItemModel {
  final String date;
  final String vendorName;
  final String productName;
  final int quantity;
  final String unit;
  final String productCode;
  final double totalValue;

  PurchaseItemModel({
    required this.date,
    required this.vendorName,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.productCode,
    required this.totalValue,
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseItemModel(
      date: json['date'] ?? '',
      vendorName: json['vendor_name'] ?? '',
      productName: json['product_name'] ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unit: json['unit'] ?? '',
      productCode: json['product_code'] ?? '',
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'vendor_name': vendorName,
      'product_name': productName,
      'quantity': quantity,
      'unit': unit,
      'product_code': productCode,
      'total_value': totalValue,
    };
  }
}
