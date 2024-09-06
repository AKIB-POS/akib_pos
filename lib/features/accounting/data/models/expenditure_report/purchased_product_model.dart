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
      date: json['date'],
      amount: json['amount'].toDouble(),
      productName: json['product_name'],
      expenditureCategory: json['expenditure_category'],
    );
  }
}
