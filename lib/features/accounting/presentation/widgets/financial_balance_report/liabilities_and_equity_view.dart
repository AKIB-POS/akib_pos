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
          return Utils.buildLoadingCardShimmer();
        } else if (state is FinancialBalanceLoaded) {
          final liabilitiesAndEquity = state.financialBalance.liabilitiesAndOwnerEquity;
          return _buildLiabilitiesAndEquityView(liabilitiesAndEquity);
        } else if (state is FinancialBalanceError) {
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
          Utils.buildEmptyStatePlain(state.message,
                      "Silahkan Swipe Kebawah\nUntuk Memuat Ulang"),
          
        ],
      ),
    );
        }
        return const SizedBox.shrink();
      },
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
          ShimmerWidget.rectangular(height: 20, width: 100,),
          SizedBox(height: 8),
          ShimmerWidget.rectangular(height: 20, width: 100,),
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
          const Padding(
            padding: EdgeInsets.only(left: 16,bottom: 8),
            child: const Text("Liabilitas Lancar", style: AppTextStyle.bigCaptionBold),
          ),
          _buildRow("Hutang Dagang", Utils.formatCurrencyDouble(liabilitiesAndEquity.currentLiabilities.tradePayables)),
          const Padding(
            padding: EdgeInsets.only(left: 16,bottom: 8),
            child: Text("Ekuitas Pemilik", style: AppTextStyle.bigCaptionBold),
          ),
          _buildRow("Laba Ditahan", Utils.formatCurrencyDouble(liabilitiesAndEquity.ownerEquity.retainedEarnings)),
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
