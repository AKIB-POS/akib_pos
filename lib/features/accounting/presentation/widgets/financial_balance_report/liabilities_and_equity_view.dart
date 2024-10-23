import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/financial_balance_report/financial_balance_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/financial_balance_report/financial_balance_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/shimmer_widget.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiabilitiesAndEquityView extends StatelessWidget {
  const LiabilitiesAndEquityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialBalanceCubit, FinancialBalanceState>(
      builder: (context, state) {
        if (state is FinancialBalanceLoading) {
          return _buildLoadingShimmer();
        } else if (state is FinancialBalanceLoaded) {
          final liabilitiesAndEquity = state.financialBalance.liabilitiesAndOwnerEquity;
          return _buildLiabilitiesAndEquityView(liabilitiesAndEquity);
        } else if (state is FinancialBalanceError) {
          return _buildErrorState(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warningMain.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              "Liabilitas & Modal Pemilik",
              style: AppTextStyle.bigCaptionBold
                  .copyWith(color: AppColors.warningMain),
            ),
          ),
          Utils.buildEmptyStatePlain(message, "Silahkan Swipe Kebawah\nUntuk Memuat Ulang"),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rectangular(height: 20, width: 150),
          SizedBox(height: 8),
          ShimmerWidget.rectangular(height: 20, width: 100),
          SizedBox(height: 8),
          ShimmerWidget.rectangular(height: 20, width: 100),
        ],
      ),
    );
  }

  Widget _buildLiabilitiesAndEquityView(LiabilitiesAndOwnerEquity liabilitiesAndEquity) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warningMain.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              "Liabilitas & Modal Pemilik",
              style: AppTextStyle.bigCaptionBold
                  .copyWith(color: AppColors.warningMain),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Liabilitas Lancar Section
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text("Liabilitas Lancar", style: AppTextStyle.bigCaptionBold),
          ),
          ...liabilitiesAndEquity.currentLiabilities.map(
            (liability) => _buildRow(liability.name, Utils.formatCurrencyDouble(liability.balance)),
          ),

          // Liabilitas Jangka Panjang Section (if available)
          if (liabilitiesAndEquity.longTermLiabilities.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8, top: 8),
              child: Text("Liabilitas Jangka Panjang", style: AppTextStyle.bigCaptionBold),
            ),
            ...liabilitiesAndEquity.longTermLiabilities.map(
              (liability) => _buildRow(liability.name, Utils.formatCurrencyDouble(liability.balance)),
            ),
          ],

          // Ekuitas Pemilik Section
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8, top: 16),
            child: Text("Ekuitas Pemilik", style: AppTextStyle.bigCaptionBold),
          ),
          ...liabilitiesAndEquity.ownerEquity.map(
            (equity) => _buildRow(equity.name, Utils.formatCurrencyDouble(equity.balance)),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.caption),
          Text(value, style: AppTextStyle.caption),
        ],
      ),
    );
  }
}
