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
  final int companyId;
  final int branchId;
  final String orderType;
  final int? cashRegisterId;
  final String? createdAt; // New field for created_at

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
    this.companyId = 1,
    this.branchId = 1,
    required this.orderType,
    this.cashRegisterId,
    this.createdAt, // Initialize the new field
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
    String? orderType,
    int? cashRegisterId,
    String? createdAt, // Include new field in copyWith
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
      companyId: companyId ?? this.companyId,
      branchId: branchId ?? this.branchId,
      orderType: orderType ?? this.orderType,
      cashRegisterId: cashRegisterId ?? this.cashRegisterId,
      createdAt: createdAt ?? this.createdAt, // Include new field
    );
  }

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
      'companyId': companyId,
      'branchId': branchId,
      'orderType': orderType,
      'cash_register_id': cashRegisterId,
      'created_at': createdAt, // Include in JSON output
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'transactions': transactions.map((t) => t.toApiJson()).toList(),
      'totalPrice': totalPrice,
      'discount': discount,
      'tax': tax,
      'customerId': customerId,
      'paymentMethod': paymentMethod,
      'paymentAmount': paymentAmount,
      'companyId': companyId,
      'branchId': branchId,
      'orderType': orderType,
      'cash_register_id': cashRegisterId,
      'created_at': createdAt, // Include in API JSON output
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
      companyId: json['companyId'] ?? 1,
      branchId: json['branchId'] ?? 1,
      orderType: json['orderType'],
      cashRegisterId: json['cash_register_id'],
      createdAt: json['created_at'], // Parse the new field
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
        'orderType: $orderType, '
        'cashRegisterId: $cashRegisterId, '
        'createdAt: $createdAt'
        '}';
  }
}