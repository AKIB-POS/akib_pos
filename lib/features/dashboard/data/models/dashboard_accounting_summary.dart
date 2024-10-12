class DashboardAccountingSummaryResponse {
  final double totalProfit;
  final double totalSales;
  final int productsSold;
  final double totalPurchases;
  final double totalExpenses;

  DashboardAccountingSummaryResponse({
    required this.totalProfit,
    required this.totalSales,
    required this.productsSold,
    required this.totalPurchases,
    required this.totalExpenses,
  });

  factory DashboardAccountingSummaryResponse.fromJson(Map<String, dynamic> json) {
    return DashboardAccountingSummaryResponse(
      totalProfit: (json['total_profit'] as num).toDouble(),
      totalSales: (json['total_sales'] as num).toDouble(),
      productsSold: json['products_sold'],
      totalPurchases: (json['total_purchases'] as num).toDouble(),
      totalExpenses: (json['total_expenses'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_profit': totalProfit,
      'total_sales': totalSales,
      'products_sold': productsSold,
      'total_purchases': totalPurchases,
      'total_expenses': totalExpenses,
    };
  }
}
