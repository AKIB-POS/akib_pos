class CloseCashierResponse {
  final String message;
  final CashierData data;

  CloseCashierResponse({required this.message, required this.data});

  factory CloseCashierResponse.fromJson(Map<String, dynamic> json) {
    return CloseCashierResponse(
      message: json['message'] ?? '', // Default to empty string if missing
      data: CashierData.fromJson(json['data'] ?? {}), // Safely handle missing data field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
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
      cashierName: json['cashier_name'] ?? '', // Default to empty string if missing
      cashierOpenTime: json['cashier_open_time'] ?? '', // Default to empty string if missing
      cashierCloseTime: json['cashier_close_time'] ?? '', // Default to empty string if missing
      initialCash: (json['initial_cash'] as num?)?.toDouble() ?? 0.0, // Safely cast to double, default to 0.0
      outletExpenditure: (json['outlet_expenditure'] as num?)?.toDouble() ?? 0.0, // Safely cast
      cashPayment: (json['cash_payment'] as num?)?.toDouble() ?? 0.0, // Safely cast
      nonCashPayment: (json['non_cash_payment'] as num?)?.toDouble() ?? 0.0, // Safely cast
      totalCash: (json['total_cash'] as num?)?.toDouble() ?? 0.0, // Safely cast
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cashier_name': cashierName,
      'cashier_open_time': cashierOpenTime,
      'cashier_close_time': cashierCloseTime,
      'initial_cash': initialCash,
      'outlet_expenditure': outletExpenditure,
      'cash_payment': cashPayment,
      'non_cash_payment': nonCashPayment,
      'total_cash': totalCash,
    };
  }
}
