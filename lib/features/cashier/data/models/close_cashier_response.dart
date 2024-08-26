class CloseCashierResponse {
  final String message;
  final CashierData data;

  CloseCashierResponse({required this.message, required this.data});

  factory CloseCashierResponse.fromJson(Map<String, dynamic> json) {
    return CloseCashierResponse(
      message: json['message'],
      data: CashierData.fromJson(json['data']),
    );
  }
}

class CashierData {
  final String cashierName;
  final String cashierOpenTime;
  final String cashierCloseTime;
  final double initialCash;
  final double outletExpenditure;
  final double cashPayment;
  final double nonCashPayment;
  final double totalCash;

  CashierData({
    required this.cashierName,
    required this.cashierOpenTime,
    required this.cashierCloseTime,
    required this.initialCash,
    required this.outletExpenditure,
    required this.cashPayment,
    required this.nonCashPayment,
    required this.totalCash,
  });

  factory CashierData.fromJson(Map<String, dynamic> json) {
    return CashierData(
      cashierName: json['cashier_name'],
      cashierOpenTime: json['cashier_open_time'],
      cashierCloseTime: json['cashier_close_time'],
      initialCash: json['initial_cash'].toDouble(),
      outletExpenditure: json['outlet_expenditure'].toDouble(),
      cashPayment: json['cash_payment'].toDouble(),
      nonCashPayment: json['non_cash_payment'].toDouble(),
      totalCash: json['total_cash'].toDouble(),
    );
  }
}
