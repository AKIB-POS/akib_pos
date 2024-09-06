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
      date: json['date'],
      vendorName: json['vendor_name'],
      productName: json['product_name'],
      quantity: json['quantity'],
      unit: json['unit'],
      productCode: json['product_code'],
      totalValue: json['total_value'],
    );
  }
}
