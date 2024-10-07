import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/financial_balance_report/financial_balance_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalAssetsAndLiabilitiesView extends StatelessWidget {
  const TotalAssetsAndLiabilitiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialBalanceCubit, FinancialBalanceState>(
      builder: (context, state) {
        if (state is FinancialBalanceLoading) {
          return Utils.buildLoadingCardShimmer();
        } else if (state is FinancialBalanceLoaded) {
          final totalAssets = state.financialBalance.totalAssets;
          final totalLiabilitiesAndEquity = state.financialBalance.totalLiabilitiesAndEquity;
          return _buildTotalView(totalAssets, totalLiabilitiesAndEquity);
        } else if (state is FinancialBalanceError) {
          return Container(
             decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
            child: Center(child: Text("Error: ${state.message} Swipe Kebawah Untul load Ulang")));
        }
        return const SizedBox.shrink();
      },
    );
  }

  
  Widget _buildTotalView(double totalAssets, double totalLiabilitiesAndEquity) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.successMain,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Total Aset",
                    style: AppTextStyle.caption.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Utils.formatCurrencyDouble(totalAssets),
                    style: AppTextStyle.bigCaptionBold.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.warningMain,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Total Liabilitas & Modal",
                    style: AppTextStyle.caption.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Utils.formatCurrencyDouble(totalLiabilitiesAndEquity),
                    style: AppTextStyle.bigCaptionBold.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
