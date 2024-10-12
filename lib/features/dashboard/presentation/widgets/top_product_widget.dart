import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/dashboard/data/models/top_products.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_top_products_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class TopProductWidget extends StatefulWidget {
  final int branchId;

  const TopProductWidget({Key? key, required this.branchId}) : super(key: key);

  @override
  _TopProductWidgetState createState() => _TopProductWidgetState();
}

class _TopProductWidgetState extends State<TopProductWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDashboardTopProductsCubit, GetDashboardTopProductsState>(
      builder: (context, state) {
        if (state is GetDashboardTopProductsLoading) {
          return _buildShimmerLoading(); // Show shimmer when loading
        } else if (state is GetDashboardTopProductsError) {
          return Utils.buildErrorStatePlain(
            title: 'Gagal Memuat Produk',
            message: state.message,
            onRetry: () {
              context.read<GetDashboardTopProductsCubit>().fetchTopProducts(branchId:  widget.branchId);
            },
          );
        } else if (state is GetDashboardTopProductsLoaded) {
          final topProducts = state.topProductsResponse.topProducts;
          final totalProducts = topProducts.length;

          if (totalProducts == 0) {
            return Utils.buildEmptyStatePlain("Belum ada data produk terjual", "Produk Akan Muncul Ketika Telah Ada Transaksi");
          }

          final String title = 'Top ${totalProducts > 1 ? '$totalProducts Produk' : 'Produk'}';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.headline4),
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
                      _buildPieChart(topProducts),
                      const SizedBox(height: 16),
                      _buildLegend(topProducts),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink(); // In case of any unexpected state
        }
      },
    );
  }

  // Shimmer loading effect for top products
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
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 20,
              width: 300,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Build the Pie Chart with touch support
  Widget _buildPieChart(List<TopProduct> topProducts) {
    return SizedBox(
      height: 200, // Adjust the height as necessary
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          sections: _buildPieChartSections(topProducts),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  // Build PieChart sections with touchable interaction
  List<PieChartSectionData> _buildPieChartSections(List<TopProduct> topProducts) {
    final List<Color> colors = [
      AppColors.successMain,
      AppColors.infoMain,
      AppColors.warningMain,
      AppColors.errorMain,
      AppColors.pearlMain,
    ];

    return List.generate(topProducts.length, (index) {
      final product = topProducts[index];
      final isTouched = index == touchedIndex; // Check if this section is touched
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: colors[index % colors.length], // Cycle through colors if more than available
        value: product.percentage.toDouble(),
        title: '${product.percentage}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  // Handle the legend items with Wrap to avoid overflow issues
  Widget _buildLegend(List<TopProduct> topProducts) {
    final List<Color> colors = [
      AppColors.successMain,
      AppColors.infoMain,
      AppColors.warningMain,
      AppColors.errorMain,
      AppColors.pearlMain,
    ];

    return Wrap(
      spacing: 16, // Space between items
      runSpacing: 8, // Space between rows when wrapping
      children: List.generate(topProducts.length, (index) {
        final product = topProducts[index];
        return _buildLegendItem(colors[index % colors.length], product.productName); // Cycle colors if more products
      }),
    );
  }

  Widget _buildLegendItem(Color color, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center, // Ensure row doesn't take full width
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
}
