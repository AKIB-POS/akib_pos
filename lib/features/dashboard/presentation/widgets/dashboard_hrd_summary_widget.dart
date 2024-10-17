import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/dashboard/data/models/dashboard_summary_response.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_summary_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgProvider;

class DashboardHrdSummaryWidget extends StatelessWidget {
  final int branchId;

  const DashboardHrdSummaryWidget({Key? key, required this.branchId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDashboardSummaryHrdCubit,
        GetDashboardSummaryHrdState>(
      builder: (context, state) {
        if (state is GetDashboardSummaryHrdLoading) {
          return _buildShimmerLoading(); // Shimmer loading effect
        } else if (state is GetDashboardSummaryHrdError) {
          return Utils.buildErrorStatePlain(
            title: 'Gagal Memuat Data HRD',
            message: state.message,
            onRetry: () {
              context
                  .read<GetDashboardSummaryHrdCubit>()
                  .fetchDashboardHrdSummary(branchId: branchId);
            },
          );
        } else if (state is GetDashboardSummaryHrdLoaded) {
          final hrdSummary = state.hrdSummary;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 16),
                child: Text("Dashboard HRD", style: AppTextStyle.headline5),
              ),
              _buildUiTotalEmployee(hrdSummary.totalEmployees), // Tota
              _buildHrdPieChart(
                  hrdSummary), // Pie chart for on-time, late, and absent data
            ],
          );
        } else {
          return const SizedBox.shrink(); // Handle unexpected state
        }
      },
    );
  }

  // Widget for total employees
  Widget _buildUiTotalEmployee(int totalEmployee) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
            image: svgProvider.Svg('assets/images/hrd/bg_total_employee.svg'),
            fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Pegawai",
              style: AppTextStyle.caption.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          Text("$totalEmployee Orang",
              style: AppTextStyle.bigCaptionBold.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  // Build the HRD Pie Chart
  Widget _buildHrdPieChart(DashboardSummaryHrdResponse hrdSummary) {
    final totalEmployees = hrdSummary.totalEmployees;
    final onTime = hrdSummary.onTime ?? 0;
    final late = hrdSummary.late ?? 0;
    final absent = hrdSummary.absent ?? 0;

    final data = [
      if (onTime > 0)
        PieChartSectionData(
          value: onTime.toDouble(),
          color: AppColors.successMain,
          title: onTime.toString(),
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      if (late > 0)
        PieChartSectionData(
            value: late.toDouble(),
            color: AppColors.warningMain,
            title: late.toString(),
            titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
            ),
            
      if (absent > 0)
        PieChartSectionData(
            value: absent.toDouble(),
            color: AppColors.errorMain,
            title: absent.toString(),
            titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Kehadiran Karyawan", style: AppTextStyle.headline5),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: data,
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLegend(hrdSummary), // Legend for the pie chart
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to calculate percentage

  // Build legend for onTime, late, and absent
  Widget _buildLegend(DashboardSummaryHrdResponse hrdSummary) {
    final legends = [
      if (hrdSummary.onTime > 0)
        _buildLegendItem(AppColors.successMain, 'Tepat Waktu'),
      if (hrdSummary.late > 0)
        _buildLegendItem(AppColors.warningMain, 'Terlambat'),
      if (hrdSummary.absent > 0) _buildLegendItem(AppColors.errorMain, 'Absen'),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      children: legends,
    );
  }

  Widget _buildLegendItem(Color color, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyle.caption),
      ],
    );
  }

  // Shimmer loading effect
  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 20,
              width: 150,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
