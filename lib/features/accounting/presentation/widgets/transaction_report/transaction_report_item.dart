import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class TransactionReportItem extends StatelessWidget {
  final String title;
  final String? amount;
  final bool isLoading;

  const TransactionReportItem({
    Key? key,
    required this.title,
    this.amount,
    this.isLoading = false,  // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.caption
            ),
            const SizedBox(height: 20),
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.grey[300],
                    ),
                  )
                : Text(
                    amount ?? '',
                    style: AppTextStyle.headline5.copyWith(color: AppColors.successMain)
                  ),
          ],
        ),
      ),
    );
  }
}