class SalesReportModel {
  final double totalSales;
  final double totalCostOfGoodsSold;

  SalesReportModel({
    required this.totalSales,
    required this.totalCostOfGoodsSold,
  });

  factory SalesReportModel.fromJson(Map<String, dynamic> json) {
    return SalesReportModel(
      totalSales: json['total_sales'],
      totalCostOfGoodsSold: json['total_cost_of_goods_sold'],
    );
  }
}
