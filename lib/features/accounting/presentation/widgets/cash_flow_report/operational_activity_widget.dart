import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/cash_flow_report/cash_flow_report_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/cash_flow_report/cash_flow_report_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class OperasionalActivityWidget extends StatelessWidget {
  const OperasionalActivityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashFlowReportCubit, CashFlowReportState>(
      builder: (context, state) {
        if (state is CashFlowReportLoading) {
          return buildLoadingShimmer();
        } else if (state is CashFlowReportError) {
          return Center(child: Text(state.message));
        } else if (state is CashFlowReportSuccess) {
          return _buildOperationalActivity(state.report.operationalActivities);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildOperationalActivity(OperationalActivities operationalActivities) {
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
              "Aktivitas Operasional",
              style: AppTextStyle.bigCaptionBold,
            ),
          ),
          const SizedBox(height: 8),
          _buildRow("Penerimaan dari Pelanggan", Utils.formatCurrencyDouble(operationalActivities.customerRevenue)),
          _buildRow("Beban Operasional", Utils.formatCurrencyDouble(operationalActivities.operationalExpense)),
          _buildRowBold("Kas Bersih Aktivitas\nOperasional", Utils.formatCurrencyDouble(operationalActivities.netOperationalCash)),
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

  Widget buildLoadingShimmer() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 40,
              color: Colors.grey[300],
              margin: const EdgeInsets.all(16),
            ),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[300],
              margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
            ),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[300],
              margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
            ),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[300],
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            ),
          ],
        ),
      ),
    );
  }
}
