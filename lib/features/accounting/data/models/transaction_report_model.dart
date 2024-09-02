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
      openingCash: json['opening_cash'],
      outletExpenses: json['outlet_expenses'],
      cashPayment: json['cash_payment'],
      nonCashPayment: json['non_cash_payment'],
      totalCash: json['total_cash'],
    );
  }
}
