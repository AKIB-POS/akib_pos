class ExpiredStock {
  final String itemName;
  final String quantity;
  final String vendor;
  final String expiryDate;

  ExpiredStock({
    required this.itemName,
    required this.quantity,
    required this.vendor,
    required this.expiryDate,
  });

  // Factory constructor for creating an instance from JSON
  factory ExpiredStock.fromJson(Map<String, dynamic> json) {
    return ExpiredStock(
      itemName: json['item_name'] ?? '',
      quantity: json['quantity'] ?? '0', // Default to '0' if null
      vendor: json['vendor'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'quantity': quantity,
      'vendor': vendor,
      'expiry_date': expiryDate,
    };
  }
}

class ExpiredStockResponse {
  final List<ExpiredStock> expiredStocks;

  ExpiredStockResponse({required this.expiredStocks});

  // Factory constructor for creating an instance from JSON
  factory ExpiredStockResponse.fromJson(Map<String, dynamic> json) {
    var stocks = (json['data'] as List)
        .map((stock) => ExpiredStock.fromJson(stock))
        .toList();
    return ExpiredStockResponse(expiredStocks: stocks);
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': expiredStocks.map((stock) => stock.toJson()).toList(),
    };
  }
}
