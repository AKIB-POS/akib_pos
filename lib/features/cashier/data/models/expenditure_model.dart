class ExpenditureModel {
  final String date;
  final double amount;
  final String category;
  final String description;
  final int branchId;
  final int cashRegisterId; // Field for cash register ID

  ExpenditureModel({
    required this.date,
    required this.amount,
    required this.category,
    required this.description,
    this.branchId = 0,
    this.cashRegisterId = 0, // Default to 0 if not provided
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'category': category,
      'description': description,
      'branch_id': branchId, // Correct JSON key
      'cash_register_id': cashRegisterId, // Include cash register ID
    };
  }

  factory ExpenditureModel.fromJson(Map<String, dynamic> json) {
    return ExpenditureModel(
      date: json['date'] ?? '', // Default to empty string if null
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0, // Safely cast to double, default to 0.0
      category: json['category'] ?? '', // Default to empty string if null
      description: json['description'] ?? '', // Default to empty string if null
      branchId: (json['branch_id'] as num?)?.toInt() ?? 0, // Safely cast to int, default to 0
      cashRegisterId: (json['cash_register_id'] as num?)?.toInt() ?? 0, // Safely cast to int, default to 0
    );
  }
}
