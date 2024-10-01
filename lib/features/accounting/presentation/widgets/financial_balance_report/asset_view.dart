import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/financial_balance_report/financial_balance_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/financial_balance_report/financial_balance_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/shimmer_widget.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetsView extends StatelessWidget {
  const AssetsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialBalanceCubit, FinancialBalanceState>(
      builder: (context, state) {
        if (state is FinancialBalanceLoading) {
          return Utils.buildLoadingCardShimmer();
        } else if (state is FinancialBalanceLoaded) {
          final assets = state.financialBalance.assets;
          return _buildAssetsView(assets);
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
              color: AppColors.successMain.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              "Aset",
              style: AppTextStyle.bigCaptionBold
                  .copyWith(color: AppColors.successMain),
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
          ShimmerWidget.rectangular(height: 20, width: 100),
          SizedBox(height: 8),
          ShimmerWidget.rectangular(height: 20, width: 100,),
          SizedBox(height: 8),
          ShimmerWidget.rectangular(height: 20, width: 100,),
        ],
      ),
    );
  }

  Widget _buildAssetsView(Assets assets) {
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
              color: AppColors.successMain.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              "Aset",
              style: AppTextStyle.bigCaptionBold
                  .copyWith(color: AppColors.successMain),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 16,bottom: 8),
            child: Text("Aset Lancar", style: AppTextStyle.bigCaptionBold),
          ),
          _buildRow("Kas", Utils.formatCurrencyDouble(assets.currentAssets.cash)),
          _buildRow("Persediaan", Utils.formatCurrencyDouble(assets.currentAssets.inventory)),
          const Padding(
            padding: EdgeInsets.only(left: 16,bottom: 8),
            child: Text("Aset Tetap", style: AppTextStyle.bigCaptionBold),
          ),
          _buildRow("Bangunan", Utils.formatCurrencyDouble(assets.fixedAssets.buildingValue)),
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
