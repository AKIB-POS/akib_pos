class PurchaseChart {
  final String date;
  final double totalPurchase;

  PurchaseChart({
    required this.date,
    required this.totalPurchase,
  });

  // Factory constructor for creating an instance from JSON
  factory PurchaseChart.fromJson(Map<String, dynamic> json) {
    return PurchaseChart(
      date: json['date'] ?? '',
      totalPurchase: (json['total_purchase'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'total_purchase': totalPurchase,
    };
  }
}

class PurchaseChartResponse {
  final List<PurchaseChart> purchaseData;

  PurchaseChartResponse({required this.purchaseData});

  // Factory constructor for creating an instance from JSON
  factory PurchaseChartResponse.fromJson(Map<String, dynamic> json) {
    var purchaseList = (json['data'] as List)
        .map((purchase) => PurchaseChart.fromJson(purchase))
        .toList();
    return PurchaseChartResponse(purchaseData: purchaseList);
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': purchaseData.map((purchase) => purchase.toJson()).toList(),
    };
  }
}
