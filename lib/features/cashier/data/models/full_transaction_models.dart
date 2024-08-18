import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';

class SaveTransactionModel {
  final List<TransactionModel> transactions;
  final String savedNotes;
  final DateTime time; // Add this line

  SaveTransactionModel({
    required this.transactions,
    required this.savedNotes,
    required this.time, // Add this line
  });

  Map<String, dynamic> toJson() => {
    'transactions': transactions.map((t) => t.toJson()).toList(),
    'savedNotes': savedNotes,
    'time': time.toIso8601String(), // Add this line
  };

  factory SaveTransactionModel.fromJson(Map<String, dynamic> json) => SaveTransactionModel(
    transactions: (json['transactions'] as List)
        .map((item) => TransactionModel.fromJson(item))
        .toList(),
    savedNotes: json['savedNotes'],
    time: DateTime.parse(json['time']), // Add this line
  );
}
