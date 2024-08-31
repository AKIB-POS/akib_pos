class ExpenditureModel {
  final String date;
  final double amount;
  final String category;
  final String description;
  final int branchId;
  final int cashRegisterId; // New field for cash register ID

  ExpenditureModel({
    required this.date,
    required this.amount,
    required this.category,
    required this.description,
    this.branchId = 0,
    this.cashRegisterId = 0, // Initialize the new field
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'category': category,
      'description': description,
      'branch_id': branchId, // Corrected JSON key
      'cash_register_id': cashRegisterId, // Include in JSON output
    };
  }

  factory ExpenditureModel.fromJson(Map<String, dynamic> json) {
    return ExpenditureModel(
      date: json['date'],
      amount: double.parse(json['amount']), // Parsing the amount as double
      category: json['category'],
      description: json['description'],
      branchId: json['branch_id'], // Corrected JSON key
      cashRegisterId: json['cash_register_id'], // Parse the new field
    );
  }
}
