class TotalPurchaseModel {
  final double totalPurchase;

  TotalPurchaseModel({
    required this.totalPurchase,
  });

  factory TotalPurchaseModel.fromJson(Map<String, dynamic> json) {
    return TotalPurchaseModel(
      totalPurchase: json['total_purchase'],
    );
  }
}
