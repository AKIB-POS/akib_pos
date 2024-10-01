class CashFlowReportModel {
  final OperationalActivities operationalActivities;
  final InvestmentActivities investmentActivities;
  final FinancingActivities financingActivities;
  final double finalCashBalance;

  CashFlowReportModel({
    required this.operationalActivities,
    required this.investmentActivities,
    required this.financingActivities,
    required this.finalCashBalance,
  });

  factory CashFlowReportModel.fromJson(Map<String, dynamic> json) {
    return CashFlowReportModel(
      operationalActivities: OperationalActivities.fromJson(json['operational_activities']),
      investmentActivities: InvestmentActivities.fromJson(json['investment_activities']),
      financingActivities: FinancingActivities.fromJson(json['financing_activities']),
      finalCashBalance: (json['final_cash_balance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OperationalActivities {
  final double customerRevenue;
  final double operationalExpense;
  final double netOperationalCash;

  OperationalActivities({
    required this.customerRevenue,
    required this.operationalExpense,
    required this.netOperationalCash,
  });

  factory OperationalActivities.fromJson(Map<String, dynamic> json) {
    return OperationalActivities(
      customerRevenue: (json['customer_revenue'] as num?)?.toDouble() ?? 0.0,
      operationalExpense: (json['operational_expense'] as num?)?.toDouble() ?? 0.0,
      netOperationalCash: (json['net_operational_cash'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class InvestmentActivities {
  final double assetSale;
  final double assetPurchase;
  final double netInvestmentCash;

  InvestmentActivities({
    required this.assetSale,
    required this.assetPurchase,
    required this.netInvestmentCash,
  });

  factory InvestmentActivities.fromJson(Map<String, dynamic> json) {
    return InvestmentActivities(
      assetSale: (json['asset_sale'] as num?)?.toDouble() ?? 0.0,
      assetPurchase: (json['asset_purchase'] as num?)?.toDouble() ?? 0.0,
      netInvestmentCash: (json['net_investment_cash'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class FinancingActivities {
  final double equity;
  final double dividendPayment;
  final double prive;
  final double netFinancingCash;

  FinancingActivities({
    required this.equity,
    required this.dividendPayment,
    required this.prive,
    required this.netFinancingCash,
  });

  factory FinancingActivities.fromJson(Map<String, dynamic> json) {
    return FinancingActivities(
      equity: (json['equity'] as num?)?.toDouble() ?? 0.0,
      dividendPayment: (json['dividend_payment'] as num?)?.toDouble() ?? 0.0,
      prive: (json['prive'] as num?)?.toDouble() ?? 0.0,
      netFinancingCash: (json['net_financing_cash'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
