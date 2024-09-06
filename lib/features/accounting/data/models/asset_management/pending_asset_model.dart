class PendingAssetModel {
  final String date;
  final String itemName;
  final String invoiceNumber;
  final double acquisitionCost;

  PendingAssetModel({
    required this.date,
    required this.itemName,
    required this.invoiceNumber,
    required this.acquisitionCost,
  });

  // Factory constructor untuk membuat instance dari JSON
  factory PendingAssetModel.fromJson(Map<String, dynamic> json) {
    return PendingAssetModel(
      date: json['date'] ?? '',
      itemName: json['item_name'] ?? '',
      invoiceNumber: json['invoice_number'] ?? '',
      acquisitionCost: (json['acquisition_cost'] ?? 0).toDouble(),
    );
  }

  // Method untuk mengkonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'item_name': itemName,
      'invoice_number': invoiceNumber,
      'acquisition_cost': acquisitionCost,
    };
  }
}
