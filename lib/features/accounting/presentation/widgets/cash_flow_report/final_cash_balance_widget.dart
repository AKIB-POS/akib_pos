import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/cash_flow_report/cash_flow_report_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class FinalCashBalanceWidget extends StatelessWidget {
  const FinalCashBalanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashFlowReportCubit, CashFlowReportState>(
      builder: (context, state) {
        if (state is CashFlowReportLoading) {
          return _buildShimmer();
        } else if (state is CashFlowReportSuccess) {
          return _buildFinalCashBalance(state.report.finalCashBalance);
        } else if (state is CashFlowReportError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildFinalCashBalance(double finalCashBalance) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.successMain, // Ganti dengan warna hijau yang diinginkan
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
            "Saldo Kas Akhir",
            style: AppTextStyle.caption.copyWith(color: Colors.white), // Gaya untuk teks kecil
          ),
          const SizedBox(height: 8),
          Text(
            Utils.formatCurrencyDouble(finalCashBalance), // Format sesuai kebutuhan
            style: AppTextStyle.headline5.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.grey, // Placeholder color for shimmer
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
            "Saldo Kas Akhir",
            style: AppTextStyle.caption.copyWith(color: Colors.white), // Gaya untuk teks kecil
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 150,
              height: 24,
              color: Colors.grey[300], // Placeholder for final cash balance shimmer
            ),
          ),
        ],
      ),
    );
  }
}

