import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_summary_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TodayTransactionSummary extends StatelessWidget {
  final TransactionSummaryState state;

  TodayTransactionSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is TransactionSummaryLoading) {
      return _buildLoading();
    } else if (state is TransactionSummarySuccess) {
      final summary = (state as TransactionSummarySuccess).summary;
      return _buildSummary(summary.data.profit, summary.data.unitsSold);
    } else if (state is TransactionSummaryError) {
      final errorMessage = (state as TransactionSummaryError).message;
      return _buildSummary(null, null, errorMessage: errorMessage);
    } else {
      return _buildSummary(null, null, errorMessage: "Muat Ulang");
    }
  }

  Widget _buildLoading() {
    return _buildSummaryShimmer();
  }

  Widget _buildSummary(double? profit, int? unitsSold, {String? errorMessage}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Transaksi hari ini",
                style: AppTextStyle.headline5,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBackgorund,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          profit != null
                              ? Utils.formatCurrencyDouble(profit)
                              : 'Gagal',
                          style: AppTextStyle.bigCaptionBold.copyWith(
                            color: profit != null
                                ? AppColors.primaryMain
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          "Keuntungan",
                          style: AppTextStyle.caption,
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    Column(
                      children: [
                        Text(
                          unitsSold != null
                              ? "$unitsSold"
                              : 'Gagal',
                          style: AppTextStyle.bigCaptionBold.copyWith(
                            color: unitsSold != null
                                ? AppColors.primaryMain
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          "Unit Terjual",
                          style: AppTextStyle.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryShimmer() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Transaksi hari ini",
                style: AppTextStyle.headline5,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBackgorund,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShimmerBox(),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _buildShimmerBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 20,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 8.0),
          Container(
            width: 80,
            height: 16,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
