// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:akib_pos/features/cashier/data/models/product_model.dart';
import 'package:akib_pos/features/cashier/data/models/redeem_voucher_response.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';

class FullTransactionModel {
  final List<SelectedVariant> selectedVariants;
  final List<SelectedAddition> selectedAdditions;
  final List<TransactionModel> transactions;
  final double totalPrice;
  final double discount;
  final double tax;
  final VoucherData? voucher;
  final int? customerId;
  final String? customerName;
  final String? customerPhone;
  String? paymentMethod;  // New field
  double? paymentAmount;  // New field

  FullTransactionModel({
    required this.selectedVariants,
    required this.selectedAdditions,
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
  });

  Map<String, dynamic> toJson() => {
        'selectedVariants': selectedVariants.map((v) => v.toJson()).toList(),
        'selectedAdditions': selectedAdditions.map((a) => a.toJson()).toList(),
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
        
      };

  factory FullTransactionModel.fromJson(Map<String, dynamic> json) => FullTransactionModel(
        selectedVariants: (json['selectedVariants'] as List).map((item) => SelectedVariant.fromJson(item)).toList(),
        selectedAdditions: (json['selectedAdditions'] as List).map((item) => SelectedAddition.fromJson(item)).toList(),
        transactions: (json['transactions'] as List).map((item) => TransactionModel.fromJson(item)).toList(),
        totalPrice: json['totalPrice'],
        discount: json['discount'],
        tax: json['tax'],
        voucher: json['voucher'] != null ? VoucherData.fromJson(json['voucher']) : null,
        customerId: json['customerId'],
        customerName: json['customerName'],
        customerPhone: json['customerPhone'],
        paymentMethod: json['paymentMethod'],
        paymentAmount: json['paymentAmount'], 
      );
}
