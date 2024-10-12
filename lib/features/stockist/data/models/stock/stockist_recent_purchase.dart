class StockistRecentPurchasesRequest {
  final int branchId;

  StockistRecentPurchasesRequest({required this.branchId});

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId.toString(),
    };
  }
}
class StockistRecentPurchase {
  final String date;
  final double purchasePrice;
  final String itemName;
  final String quantity;
  final String vendor;

  StockistRecentPurchase({
    required this.date,
    required this.purchasePrice,
    required this.itemName,
    required this.quantity,
    required this.vendor,
  });

  // Factory constructor for creating an instance from JSON
  factory StockistRecentPurchase.fromJson(Map<String, dynamic> json) {
    return StockistRecentPurchase(
      date: json['date'] ?? '',
      purchasePrice: (json['purchase_price'] as num?)?.toDouble() ?? 0.0,
      itemName: json['item_name'] ?? '',
      quantity: json['quantity'] ?? '0', // Set a default '0' if null
      vendor: json['vendor'] ?? '',
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'purchase_price': purchasePrice,
      'item_name': itemName,
      'quantity': quantity,
      'vendor': vendor,
    };
  }
}

class StockistRecentPurchasesResponse {
  final List<StockistRecentPurchase> recentPurchases;

  StockistRecentPurchasesResponse({required this.recentPurchases});

  // Factory constructor for creating an instance from JSON
  factory StockistRecentPurchasesResponse.fromJson(Map<String, dynamic> json) {
    var purchases = (json['data'] as List)
        .map((purchase) => StockistRecentPurchase.fromJson(purchase))
        .toList();
    return StockistRecentPurchasesResponse(recentPurchases: purchases);
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': recentPurchases.map((purchase) => purchase.toJson()).toList(),
    };
  }
}
