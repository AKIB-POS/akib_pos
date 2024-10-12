import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/shimmer_widget.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_accounting_summary_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgProvider;


class DashboardAccountingSummaryWidget extends StatelessWidget {
  final int branchId;

  const DashboardAccountingSummaryWidget({Key? key, required this.branchId}) : super(key: key);

@override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDashboardAccountingSummaryCubit, GetDashboardAccountingSummaryState>(
      builder: (context, state) {
        if (state is GetDashboardAccountingSummaryLoading) {
          return _buildShimmerLoading();
        } else if (state is GetDashboardAccountingSummaryError) {
          return Utils.buildErrorStatePlain(
            title: 'Gagal Memuat',
            message: state.message,
            onRetry: () {
              // Replace with actual branchId
              context.read<GetDashboardAccountingSummaryCubit>().fetchAccountingSummary(branchId: branchId);
            },
          );
        } else if (state is GetDashboardAccountingSummaryLoaded) {
          final summary = state.accountingSummary;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text("Dashboard",style: AppTextStyle.headline4.copyWith(fontWeight: FontWeight.bold),),
              ),
              _buildUiTotalProfit(summary.totalProfit),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'assets/icons/stockist/ic_total_sales.svg',
                        'Total Penjualan',
                        Utils.formatCurrencyDouble(summary.totalSales),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        'assets/icons/stockist/ic_product_sold.svg',
                        'Produk Terjual',
                        summary.productsSold.toString(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'assets/icons/stockist/ic_total_purchases.svg',
                        'Total Pembelian',
                        Utils.formatCurrencyDouble(summary.totalPurchases),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        'assets/icons/stockist/ic_total_expenses.svg',
                        'Total Pengeluaran',
                        Utils.formatCurrencyDouble(summary.totalExpenses),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Shimmer loading effect for summary widgets
  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: _buildShimmerBox(height: 100, width: double.infinity), // For Total Profit card
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: _buildShimmerBox(height: 100, width: double.infinity),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: _buildShimmerBox(height: 100, width: double.infinity),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: _buildShimmerBox(height: 100, width: double.infinity),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: _buildShimmerBox(height: 100, width: double.infinity),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to create shimmer boxes
  Widget _buildShimmerBox({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Widget to display the Total Profit card
  Widget _buildUiTotalProfit(double totalProfit) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 16,left: 16,top: 16,bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image:  const DecorationImage(
          image: svgProvider.Svg('assets/images/hrd/bg_total_employee.svg'),
          fit: BoxFit.cover
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text("Total Keuntungan", style: AppTextStyle.caption.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          Text(Utils.formatNumberDouble(totalProfit), style: AppTextStyle.bigCaptionBold.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  // Widget to display summary cards
  Widget _buildSummaryCard(String iconPath, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(iconPath, height: 40, width: 40),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyle.bigCaptionBold),
          Text(value, style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.primaryMain)),
        ],
      ),
    );
  }
  }
