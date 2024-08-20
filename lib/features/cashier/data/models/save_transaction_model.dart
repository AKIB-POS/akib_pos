import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';

class SaveTransactionModel {
  final List<TransactionModel> transactions;
  final String savedNotes;
  final DateTime time;
  final double tax; // New mandatory field
  final double? discount;
  final String? customerName;
  final String? customerPhone;
  final int? customerId;

  SaveTransactionModel({
    required this.transactions,
    required this.savedNotes,
    required this.time,
    required this.tax, // Add tax to the constructor
    this.discount,
    this.customerName,
    this.customerPhone,
    this.customerId,
  });

  Map<String, dynamic> toJson() => {
    'transactions': transactions.map((t) => t.toJson()).toList(),
    'savedNotes': savedNotes,
    'time': time.toIso8601String(),
    'tax': tax, // Include tax in the JSON output
    'discount': discount,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'customerId': customerId,
  };

  factory SaveTransactionModel.fromJson(Map<String, dynamic> json) => SaveTransactionModel(
    transactions: (json['transactions'] as List)
        .map((item) => TransactionModel.fromJson(item))
        .toList(),
    savedNotes: json['savedNotes'],
    time: DateTime.parse(json['time']),
    tax: json['tax'], // Parse tax from the JSON input
    discount: json['discount'],
    customerName: json['customerName'],
    customerPhone: json['customerPhone'],
    customerId: json['customerId'],
  );

  @override
  String toString() {
    return 'SaveTransactionModel{'
        'transactions: $transactions, '
        'savedNotes: $savedNotes, '
        'time: $time, '
        'tax: $tax, '
        'discount: $discount, '
        'customerName: $customerName, '
        'customerPhone: $customerPhone, '
        'customerId: $customerId'
        '}';
  }
}