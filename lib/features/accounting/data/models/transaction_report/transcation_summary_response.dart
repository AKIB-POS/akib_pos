class TransactionSummaryResponse {
  final String message;
  final TransactionSummaryData data;

  TransactionSummaryResponse({
    required this.message,
    required this.data,
  });

  factory TransactionSummaryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionSummaryResponse(
      message: json['message'] ?? '',
      data: TransactionSummaryData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class TransactionSummaryData {
  final double profit;
  final int unitsSold;

  TransactionSummaryData({
    required this.profit,
    required this.unitsSold,
  });

  factory TransactionSummaryData.fromJson(Map<String, dynamic> json) {
    return TransactionSummaryData(
      profit: (json['profit'] as num?)?.toDouble() ?? 0.0,
      unitsSold: (json['units_sold'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profit': profit,
      'units_sold': unitsSold,
    };
  }
}
