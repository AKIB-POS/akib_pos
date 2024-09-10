class ProfitLossModel {
  final SalesRevenue salesRevenue;
  final COGS cogs;
  final List<OperatingExpense> operatingExpenses;
  final double totalOperatingExpenses;

  ProfitLossModel({
    required this.salesRevenue,
    required this.cogs,
    required this.operatingExpenses,
    required this.totalOperatingExpenses,
  });

  factory ProfitLossModel.fromJson(Map<String, dynamic> json) {
    return ProfitLossModel(
      salesRevenue: SalesRevenue.fromJson(json['sales_revenue']),
      cogs: COGS.fromJson(json['cost_of_goods_sold']),
      operatingExpenses: (json['operating_expenses'] as List)
          .map((e) => OperatingExpense.fromJson(e))
          .toList(),
      totalOperatingExpenses: json['total_operating_expenses'],
    );
  }
}

class SalesRevenue {
  final double sales;
  final double salesDiscount;
  final double totalSales;

  SalesRevenue({
    required this.sales,
    required this.salesDiscount,
    required this.totalSales,
  });

  factory SalesRevenue.fromJson(Map<String, dynamic> json) {
    return SalesRevenue(
      sales: json['sales'],
      salesDiscount: json['sales_discount'],
      totalSales: json['total_sales'],
    );
  }
}

class COGS {
  final double totalCogs;

  COGS({required this.totalCogs});

  factory COGS.fromJson(Map<String, dynamic> json) {
    return COGS(
      totalCogs: json['total_cogs'],
    );
  }
}

class OperatingExpense {
  final String name;
  final double amount;

  OperatingExpense({
    required this.name,
    required this.amount,
  });

  factory OperatingExpense.fromJson(Map<String, dynamic> json) {
    return OperatingExpense(
      name: json['name'],
      amount: json['amount'],
    );
  }
}
