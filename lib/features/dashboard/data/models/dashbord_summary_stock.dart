class DashboardSummaryStock {
  final int totalMaterials;
  final int expiredStock;
  final int almostOutOfStock;

  DashboardSummaryStock({
    required this.totalMaterials,
    required this.expiredStock,
    required this.almostOutOfStock,
  });

  factory DashboardSummaryStock.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryStock(
      totalMaterials: json['total_materials'] ?? 0,
      expiredStock: json['expired_stock'] ?? 0,
      almostOutOfStock: json['almost_out_of_stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_materials': totalMaterials,
      'expired_stock': expiredStock,
      'almost_out_of_stock': almostOutOfStock,
    };
  }
}

class DashboardSummaryStockResponse {
  final DashboardSummaryStock stockSummary;

  DashboardSummaryStockResponse({required this.stockSummary});

  factory DashboardSummaryStockResponse.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryStockResponse(
      stockSummary: DashboardSummaryStock.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': stockSummary.toJson(),
    };
  }
}

