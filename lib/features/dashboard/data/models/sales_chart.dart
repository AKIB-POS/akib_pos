class SalesChart {
  final String date;
  final double totalSales;

  SalesChart({required this.date, required this.totalSales});

  factory SalesChart.fromJson(Map<String, dynamic> json) {
    return SalesChart(
      date: json['date'] ?? '',
      totalSales: (json['total_sales'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'total_sales': totalSales,
    };
  }
}

class SalesChartResponse {
  final List<SalesChart> salesData;

  SalesChartResponse({required this.salesData});

  factory SalesChartResponse.fromJson(Map<String, dynamic> json) {
    var sales = (json['data'] as List)
        .map((salesItem) => SalesChart.fromJson(salesItem))
        .toList();
    return SalesChartResponse(salesData: sales);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': salesData.map((salesItem) => salesItem.toJson()).toList(),
    };
  }
}
