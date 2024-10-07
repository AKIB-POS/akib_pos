import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/salary/salary_slip_detail.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/salary/detail_salary_slip_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:shimmer/shimmer.dart';

class SalarySlipsDetailContent extends StatelessWidget {
  final int slipId;

  const SalarySlipsDetailContent({Key? key, required this.slipId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailSalarySlipCubit, DetailSalarySlipState>(
      builder: (context, state) {
        if (state is DetailSalarySlipLoading) {
          return _buildLoadingShimmer();
        } else if (state is DetailSalarySlipLoaded) {
          return _buildContent(state.salarySlipDetail);
        } else if (state is DetailSalarySlipError) {
          return Utils.buildEmptyState("${state.message}", "Swipe Kebawah Untuk Refresh");
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerContainer(height: 80),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildShimmerContainer(height: 80, flex: 1),
              const SizedBox(width: 8),
              _buildShimmerContainer(height: 80, flex: 1),
            ],
          ),
          const SizedBox(height: 16),
          _buildShimmerContainer(height: 24),
          const SizedBox(height: 16),
          _buildShimmerContainer(height: 160),
          const SizedBox(height: 16),
          _buildShimmerContainer(height: 24),
          const SizedBox(height: 16),
          _buildShimmerContainer(height: 160),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({double height = 50, int flex = 0}) {
    final container = Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return flex > 0 ? Expanded(flex: flex, child: container) : container;
  }

  Widget _buildContent(SalarySlipDetail detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSalaryReceived(detail.totalSalaryReceived),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildBonusDetail(detail.totalBonus),
              const SizedBox(width: 8),
              _buildDeductionsDetail(detail.deductionsDetails),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Rincian Gaji", style: AppTextStyle.headline5),
          const SizedBox(height: 16),
          _buildEarningsDetails(detail.earningsDetails),
          const SizedBox(height: 16),
          _buildDeductionsDetails(detail.deductionsDetails),
        ],
      ),
    );
  }

  Widget _buildSalaryReceived(double totalSalaryReceived) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: Svg('assets/images/hrd/bg_green.svg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gaji Diterima',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            Utils.formatCurrencyDouble(totalSalaryReceived),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusDetail(double totalBonus) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bonus', style: AppTextStyle.caption),
            const SizedBox(height: 8),
            Text(
              Utils.formatCurrencyDouble(totalBonus),
              style:
                  AppTextStyle.bigCaptionBold.copyWith(color: AppColors.successMain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeductionsDetail(List<SalaryDetailItem> deductionsDetails) {
    final totalDeductions =
        deductionsDetails.fold<double>(0, (sum, item) => sum + item.amount);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Potongan', style: AppTextStyle.caption),
            const SizedBox(height: 8),
            Text(
              Utils.formatCurrencyDouble(totalDeductions),
              style: AppTextStyle.bigCaptionBold
                  .copyWith(color: AppColors.warningMain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsDetails(List<SalaryDetailItem> earningsDetails) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detail Pendapatan', style: AppTextStyle.headline5),
          const SizedBox(height: 8),
          Column(
            children: earningsDetails.map((e) {
              return _buildDetailItem(e.name, e.amount);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDeductionsDetails(List<SalaryDetailItem> deductionsDetails) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detail Potongan', style: AppTextStyle.headline5),
          const SizedBox(height: 8),
          Column(
            children: deductionsDetails.map((e) {
              return _buildDetailItem(e.name, e.amount);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String name, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: AppTextStyle.caption),
          Text(
            Utils.formatCurrencyDouble(amount),
            style: AppTextStyle.caption,
          ),
        ],
      ),
    );
  }
}
