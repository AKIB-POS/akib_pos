class TransactionReportModel {
  final double openingCash;
  final double outletExpenses;
  final double cashPayment;
  final double nonCashPayment;
  final double totalCash;

  TransactionReportModel({
    required this.openingCash,
    required this.outletExpenses,
    required this.cashPayment,
    required this.nonCashPayment,
    required this.totalCash,
  });

  factory TransactionReportModel.fromJson(Map<String, dynamic> json) {
    return TransactionReportModel(
      openingCash: (json['opening_cash'] as num).toDouble(),
      outletExpenses: (json['outlet_expenses'] as num).toDouble(),
      cashPayment: (json['cash_payment'] as num).toDouble(),
      nonCashPayment: (json['non_cash_payment'] as num).toDouble(),
      totalCash: (json['total_cash'] as num).toDouble(),
    );
  }
}
