import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/dashboard/data/models/purchase_chart.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_purchase_chart_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/line_chart_widget.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PurchaseChartWidget extends StatefulWidget {
  final int branchId;

  const PurchaseChartWidget({Key? key, required this.branchId}) : super(key: key);

  @override
  _PurchaseChartWidgetState createState() => _PurchaseChartWidgetState();
}

class _PurchaseChartWidgetState extends State<PurchaseChartWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPurchaseChartCubit, GetPurchaseChartState>(
      builder: (context, state) {
        if (state is GetPurchaseChartLoading) {
          return _buildShimmerLoading();  // Show shimmer loading
        } else if (state is GetPurchaseChartError) {
          return Utils.buildErrorStatePlain(
            title: 'Gagal Memuat Grafik Pembelian',
            message: state.message,
            onRetry: () {
              context.read<GetPurchaseChartCubit>().fetchPurchaseChart(branchId: widget.branchId);
            },
          );
        } else if (state is GetPurchaseChartLoaded) {
          final purchaseData = state.purchaseChart.purchaseData;

          if (purchaseData.isEmpty || purchaseData.length == 1) {
            return Utils.buildEmptyStatePlain(
              "Belum Ada Data Pembelian",
              "Grafik hanya dapat ditampilkan jika terdapat data pembelian lebih dari 1 hari."
            );
          }

          return Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Grafik Pembelian", style: AppTextStyle.headline5),
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
                  child: LineChartWidget<PurchaseChart>(
                    chartData: purchaseData,
                    lineColor: AppColors.errorMain,  // Error color for purchases
                    getDate: (data) => data.date,
                    getValue: (data) => data.totalPurchase,
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
