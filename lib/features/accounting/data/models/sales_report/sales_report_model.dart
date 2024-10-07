class SalesReportModel {
  final double totalSales;
  final double totalCostOfGoodsSold;

  SalesReportModel({
    required this.totalSales,
    required this.totalCostOfGoodsSold,
  });

  factory SalesReportModel.fromJson(Map<String, dynamic> json) {
    return SalesReportModel(
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0.0,
      totalCostOfGoodsSold: (json['total_cost_of_goods_sold'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_sales': totalSales,
      'total_cost_of_goods_sold': totalCostOfGoodsSold,
    };
  }
}
