import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/cash_flow_report/cash_flow_report_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/cash_flow_report/cash_flow_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/cash_flow_report/operational_activity_widget.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvestmentActivityWidget extends StatelessWidget {
  const InvestmentActivityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashFlowReportCubit, CashFlowReportState>(
      builder: (context, state) {
        if (state is CashFlowReportLoading) {
          return _buildLoadingShimmer();
        } else if (state is CashFlowReportError) {
           return Column(
            children: [
              Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.textGrey200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: const Text(
              "Aktivitas Investasi",
              style: AppTextStyle.bigCaptionBold,
            ),
          ),
              Utils.buildEmptyStatePlain(state.message,
                          "Silahkan Swipe Kebawah\nUntuk Memuat Ulang"),
            ],
          );
        } else if (state is CashFlowReportSuccess) {
          return _buildInvestmentActivity(state.report.investmentActivities);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildInvestmentActivity(InvestmentActivities investmentActivities) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.textGrey200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: const Text(
              "Aktivitas Investasi",
              style: AppTextStyle.bigCaptionBold,
            ),
          ),
          const SizedBox(height: 8),
          _buildRow("Penjualan Aktiva", Utils.formatCurrencyDouble(investmentActivities.assetSale)),
          _buildRow("Pembelian Aktiva", Utils.formatCurrencyDouble(investmentActivities.assetPurchase)),
          _buildRowBold("Kas Bersih Aktivitas\nInvestasi", Utils.formatCurrencyDouble(investmentActivities.netInvestmentCash)),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.caption),
          Text(value, style: AppTextStyle.caption),
        ],
      ),
    );
  }

  Widget _buildRowBold(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.bigCaptionBold),
          Text(value, style: AppTextStyle.bigCaptionBold),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return const OperasionalActivityWidget().buildLoadingShimmer(); // Reusing the same shimmer for consistency
  }
}
