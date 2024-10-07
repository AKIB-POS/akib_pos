class PurchasedProductModel {
  final String date;
  final double amount;
  final String productName;
  final String expenditureCategory;

  PurchasedProductModel({
    required this.date,
    required this.amount,
    required this.productName,
    required this.expenditureCategory,
  });

  factory PurchasedProductModel.fromJson(Map<String, dynamic> json) {
    return PurchasedProductModel(
      date: json['date'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      productName: json['product_name'] ?? '',
      expenditureCategory: json['expenditure_category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'product_name': productName,
      'expenditure_category': expenditureCategory,
    };
  }
}
