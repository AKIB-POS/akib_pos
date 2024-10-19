import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/dashboard/data/models/sales_chart.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_sales_chart_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/line_chart_widget.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class SalesChartWidget extends StatefulWidget {
  final int branchId;

  const SalesChartWidget({Key? key, required this.branchId}) : super(key: key);

  @override
  _SalesChartWidgetState createState() => _SalesChartWidgetState();
}

class _SalesChartWidgetState extends State<SalesChartWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSalesChartCubit, GetSalesChartState>(
      builder: (context, state) {
        if (state is GetSalesChartLoading) {
          return _buildShimmerLoading();
        } else if (state is GetSalesChartError) {
          return Utils.buildErrorStatePlain(
            title: 'Gagal Memuat Grafik Penjualan',
            message: state.message,
            onRetry: () {
              context.read<GetSalesChartCubit>().fetchSalesChart(branchId: widget.branchId);
            },
          );
        } else if (state is GetSalesChartLoaded) {
          final salesData = state.salesChartResponse.salesData;
          if (salesData.isEmpty || salesData.length == 1) {
            return Utils.buildEmptyStatePlain(
              "Belum Ada Data Penjualan",
              "Grafik hanya dapat ditampilkan jika terdapat data penjualan lebih dari 1 hari."
            );
          }

          return Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Grafik Penjualan", style: AppTextStyle.headline5),
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
                  child: LineChartWidget<SalesChart>(
                    chartData: salesData,
                    lineColor: AppColors.successMain,
                    getDate: (data) => data.date,
                    getValue: (data) => data.totalSales,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
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
}
