class TotalPurchaseModel {
  final double totalPurchase;

  TotalPurchaseModel({
    required this.totalPurchase,
  });

  factory TotalPurchaseModel.fromJson(Map<String, dynamic> json) {
    return TotalPurchaseModel(
      totalPurchase: (json['total_purchase'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_purchase': totalPurchase,
    };
  }
}
