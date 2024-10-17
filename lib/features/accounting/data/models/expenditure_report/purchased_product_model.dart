class PurchasedProductModel {
  final String date;
  final double amount;
  final String productName;  // Pemetaan dari 'description'
  final String expenditureCategory;  // Pemetaan dari 'category'

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
      productName: json['description'] ?? '',  // Pemetaan dari 'description'
      expenditureCategory: json['category'] ?? '',  // Pemetaan dari 'category'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'description': productName,  // Pemetaan ke 'description'
      'category': expenditureCategory,  // Pemetaan ke 'category'
    };
  }
}
