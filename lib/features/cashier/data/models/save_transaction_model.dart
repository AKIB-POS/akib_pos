import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';

class SaveTransactionModel {
  final List<TransactionModel> transactions;
  final String savedNotes;
  final DateTime time;
  final double tax;
  final double? discount;
  final String? customerName;
  final String? customerPhone;
  final int? customerId;
  final String orderType; // New field for order type

  SaveTransactionModel({
    required this.transactions,
    required this.savedNotes,
    required this.time,
    required this.tax,
    this.discount,
    this.customerName,
    this.customerPhone,
    this.customerId,
    required this.orderType, // Add order type to constructor
  });

  Map<String, dynamic> toJson() => {
    'transactions': transactions.map((t) => t.toJson()).toList(),
    'savedNotes': savedNotes,
    'time': time.toIso8601String(),
    'tax': tax,
    'discount': discount,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'customerId': customerId,
    'orderType': orderType, // Include order type in JSON
  };

  factory SaveTransactionModel.fromJson(Map<String, dynamic> json) => SaveTransactionModel(
    transactions: (json['transactions'] as List)
        .map((item) => TransactionModel.fromJson(item))
        .toList(),
    savedNotes: json['savedNotes'],
    time: DateTime.parse(json['time']),
    tax: json['tax'],
    discount: json['discount'],
    customerName: json['customerName'],
    customerPhone: json['customerPhone'],
    customerId: json['customerId'],
    orderType: json['orderType'], // Parse order type from JSON
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
        'customerId: $customerId, '
        'orderType: $orderType'
        '}';
  }
}
