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
      finalCashBalance: json['final_cash_balance'].toDouble(),
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
      customerRevenue: json['customer_revenue'].toDouble(),
      operationalExpense: json['operational_expense'].toDouble(),
      netOperationalCash: json['net_operational_cash'].toDouble(),
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
      assetSale: json['asset_sale'].toDouble(),
      assetPurchase: json['asset_purchase'].toDouble(),
      netInvestmentCash: json['net_investment_cash'].toDouble(),
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
      equity: json['equity'].toDouble(),
      dividendPayment: json['dividend_payment'].toDouble(),
      prive: json['prive'].toDouble(),
      netFinancingCash: json['net_financing_cash'].toDouble(),
    );
  }
}
