// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/redeem_voucher_response.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';

class FullTransactionModel {
  final List<TransactionModel> transactions;
  final double totalPrice;
  final double discount;
  final double tax;
  final VoucherData? voucher;
  final int? customerId;
  final String? customerName;
  final String? customerPhone;
  String? paymentMethod;
  double? paymentAmount;
  final int companyId; // New field
  final int branchId;  // New field
  final String orderType; // New field for order type

  FullTransactionModel({
    required this.transactions,
    required this.totalPrice,
    required this.discount,
    required this.tax,
    this.voucher,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.paymentMethod,
    this.paymentAmount,
    this.companyId = 1, // Default value
    this.branchId = 1, // Default value
    required this.orderType, // Required field for order type
  });

  FullTransactionModel copyWith({
    List<TransactionModel>? transactions,
    double? totalPrice,
    double? discount,
    double? tax,
    VoucherData? voucher,
    int? customerId,
    String? customerName,
    String? customerPhone,
    String? paymentMethod,
    double? paymentAmount,
    int? companyId,
    int? branchId,
    String? orderType, // Include new field in copyWith
  }) {
    return FullTransactionModel(
      transactions: transactions ?? this.transactions,
      totalPrice: totalPrice ?? this.totalPrice,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      voucher: voucher ?? this.voucher,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      companyId: companyId ?? this.companyId, // Include new field
      branchId: branchId ?? this.branchId, // Include new field
      orderType: orderType ?? this.orderType, // Include new field
    );
  }

  // General JSON serialization for full object data
  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'totalPrice': totalPrice,
      'discount': discount,
      'tax': tax,
      'voucher': voucher?.toJson(),
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'paymentMethod': paymentMethod,
      'paymentAmount': paymentAmount,
      'companyId': companyId, // Include in JSON output
      'branchId': branchId, // Include in JSON output
      'orderType': orderType, // Include in JSON output
    };
  }

  // JSON serialization tailored for API request
  Map<String, dynamic> toApiJson() {
    return {
      'transactions': transactions.map((t) => t.toApiJson()).toList(), // Use toApiJson of TransactionModel
      'totalPrice': totalPrice,
      'discount': discount,
      'tax': tax,
      'customerId': customerId,
      'paymentMethod': paymentMethod,
      'paymentAmount': paymentAmount,
      'companyId': companyId, // Include in API JSON output
      'branchId': branchId, // Include in API JSON output
      'orderType': orderType, // Include in API JSON output
    };
  }

  factory FullTransactionModel.fromJson(Map<String, dynamic> json) {
    return FullTransactionModel(
      transactions: (json['transactions'] as List)
          .map((item) => TransactionModel.fromJson(item))
          .toList(),
      totalPrice: json['totalPrice'],
      discount: json['discount'],
      tax: json['tax'],
      voucher: json['voucher'] != null ? VoucherData.fromJson(json['voucher']) : null,
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      paymentMethod: json['paymentMethod'],
      paymentAmount: json['paymentAmount'],
      companyId: json['companyId'] ?? 1, // Parse the new field, with default
      branchId: json['branchId'] ?? 1, // Parse the new field, with default
      orderType: json['orderType'], // Parse the new field for order type
    );
  }

  @override
  String toString() {
    return 'FullTransactionModel{'
        'transactions: $transactions, '
        'totalPrice: $totalPrice, '
        'discount: $discount, '
        'tax: $tax, '
        'voucher: $voucher, '
        'customerId: $customerId, '
        'customerName: $customerName, '
        'customerPhone: $customerPhone, '
        'paymentMethod: $paymentMethod, '
        'paymentAmount: $paymentAmount, '
        'companyId: $companyId, '
        'branchId: $branchId, '
        'orderType: $orderType'
        '}';
  }
}
