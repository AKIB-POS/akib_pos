class TopProduct {
  final String productName;
  final int percentage;

  TopProduct({
    required this.productName,
    required this.percentage,
  });

  // Factory constructor for creating an instance from JSON
  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      productName: json['product_name'] ?? '',
      percentage: json['percentage'] ?? 0,
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'percentage': percentage,
    };
  }
}

class TopProductsResponse {
  final List<TopProduct> topProducts;

  TopProductsResponse({required this.topProducts});

  // Factory constructor for creating an instance from JSON
  factory TopProductsResponse.fromJson(Map<String, dynamic> json) {
    var products = (json['data'] as List)
        .map((product) => TopProduct.fromJson(product))
        .toList();
    return TopProductsResponse(topProducts: products);
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': topProducts.map((product) => product.toJson()).toList(),
    };
  }
}
