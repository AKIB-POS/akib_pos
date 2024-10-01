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
      totalOperatingExpenses: (json['total_operating_expenses'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sales_revenue': salesRevenue.toJson(),
      'cost_of_goods_sold': cogs.toJson(),
      'operating_expenses': operatingExpenses.map((e) => e.toJson()).toList(),
      'total_operating_expenses': totalOperatingExpenses,
    };
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
      sales: (json['sales'] as num?)?.toDouble() ?? 0.0,
      salesDiscount: (json['sales_discount'] as num?)?.toDouble() ?? 0.0,
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sales': sales,
      'sales_discount': salesDiscount,
      'total_sales': totalSales,
    };
  }
}

class COGS {
  final double totalCogs;

  COGS({required this.totalCogs});

  factory COGS.fromJson(Map<String, dynamic> json) {
    return COGS(
      totalCogs: (json['total_cogs'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_cogs': totalCogs,
    };
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
      name: json['name'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}
