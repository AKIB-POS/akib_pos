class RunningOutStock {
  final String itemName;
  final String quantity;
  final String vendor;

  RunningOutStock({
    required this.itemName,
    required this.quantity,
    required this.vendor,
  });

  factory RunningOutStock.fromJson(Map<String, dynamic> json) {
    return RunningOutStock(
      itemName: json['item_name'] ?? '',
      quantity: json['quantity'] ?? '',
      vendor: json['vendor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'quantity': quantity,
      'vendor': vendor,
    };
  }
}

class RunningOutStockResponse {
  final List<RunningOutStock> runningOutStocks;

  RunningOutStockResponse({required this.runningOutStocks});

  factory RunningOutStockResponse.fromJson(Map<String, dynamic> json) {
    var stocks = (json['data'] as List)
        .map((stock) => RunningOutStock.fromJson(stock))
        .toList();
    return RunningOutStockResponse(runningOutStocks: stocks);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': runningOutStocks.map((stock) => stock.toJson()).toList(),
    };
  }
}
