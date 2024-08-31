class TransactionSummaryResponse {
  final String message;
  final TransactionSummaryData data;

  TransactionSummaryResponse({required this.message, required this.data});

  factory TransactionSummaryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionSummaryResponse(
      message: json['message'],
      data: TransactionSummaryData.fromJson(json['data']),
    );
  }
}

class TransactionSummaryData {
  final double profit;
  final int unitsSold;

  TransactionSummaryData({required this.profit, required this.unitsSold});

  factory TransactionSummaryData.fromJson(Map<String, dynamic> json) {
    return TransactionSummaryData(
      profit: json['profit'].toDouble(),
      unitsSold: json['units_sold'],
    );
  }
}
