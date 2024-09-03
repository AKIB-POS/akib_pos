import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/accounting_transaction_reporrt_model.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AccountingTransactionCustomerCard extends StatelessWidget {
  final AccountingTransactionReportModel transaction;

  const AccountingTransactionCustomerCard({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${transaction.transactionCode} - ${transaction.customerName ?? "Tamu"}',
                    style: AppTextStyle.caption
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (transaction.discount != null)
                        Text(
                          Utils.formatCurrencyDouble(transaction.price),
                          style: AppTextStyle.bigCaptionBold.copyWith(decoration: TextDecoration.lineThrough, color: AppColors.textGrey500),
                        ),
                        
                      if (transaction.discount != null) const SizedBox(width: 8),
                      Text(
                        Utils.formatCurrencyDouble(
                          transaction.discount != null
                              ? (transaction.price - transaction.discount!)
                              : transaction.price,
                        ),
                        style: AppTextStyle.bigCaptionBold.copyWith(color: transaction.discount != null ? AppColors.primaryMain : Colors.black))
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.orderType,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            _buildPaymentTypeBadge(transaction.paymentType),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTypeBadge(String paymentType) {
    final isCash = paymentType.toLowerCase() == 'tunai';
    final color = isCash ? AppColors.successMain.withOpacity(0.1) : AppColors.warningMain.withOpacity(0.1);
    final textColor = isCash ? AppColors.successMain : AppColors.warningMain;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        paymentType,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

