class MaterialDetailResponse {
  final String materialName;
  final String materialCode;
  final String quantity;
  final double averagePrice;

  MaterialDetailResponse({
    required this.materialName,
    required this.materialCode,
    required this.quantity,
    required this.averagePrice,
  });

  // Factory constructor for creating an instance from JSON
  factory MaterialDetailResponse.fromJson(Map<String, dynamic> json) {
    return MaterialDetailResponse(
      materialName: json['material_name'] ?? '',
      materialCode: json['material_code'] ?? '',
      quantity: json['quantity'] ?? '0',
      averagePrice: (json['average_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'material_name': materialName,
      'material_code': materialCode,
      'quantity': quantity,
      'average_price': averagePrice,
    };
  }
}
