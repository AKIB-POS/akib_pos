import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_summary_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_summary_stock_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class DashboardStockSummaryWidget extends StatelessWidget {
  final int branchId;

  const DashboardStockSummaryWidget({Key? key, required this.branchId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDashboardSummaryStockCubit, GetDashboardSummaryStockState>(
      builder: (context, state) {
        if (state is GetDashboardSummaryStockLoading) {
          return _buildShimmerLoading(); // Show shimmer when loading
        } else if (state is GetDashboardSummaryStockError) {
          return Utils.buildErrorStatePlain(
            title: 'Gagal Memuat Data Stock',
            message: state.message,
            onRetry: () {
              context.read<GetDashboardSummaryStockCubit>().fetchDashboardStockSummary(branchId: branchId);
            },
          ); 
        } else if (state is GetDashboardSummaryStockLoaded) {
          final stockSummary = state.stockSummary;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16,bottom: 16),
                child: Text("Dashboard Stock",style: AppTextStyle.headline5.copyWith(fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildUiTotalMaterials(stockSummary.totalMaterials, context),
              ),
              _buildStockStatistics(stockSummary.expiredStock, stockSummary.almostOutOfStock),
            ],
          );
        } else {
          return const SizedBox.shrink(); // Handle unexpected states
        }
      },
    );
  }

  // Method to build total materials UI
  Widget _buildUiTotalMaterials(int totalMaterials, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only( bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage('assets/images/stockist/bg_main_stockist.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Stok Barang", style: AppTextStyle.caption.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          Text("$totalMaterials", style: AppTextStyle.headline5.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  // Method to build stock statistics (expired and almost out of stock)
  Widget _buildStockStatistics(int expiredStock, int almostOutOfStock) {
    return Container(
      margin: EdgeInsets.only(bottom: 21),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Statistik Stok",
                style: AppTextStyle.headline5,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBackgorund,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "$expiredStock",
                          style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.primaryMain),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          "Stok Kedaluwarsa",
                          style: AppTextStyle.caption,
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    Column(
                      children: [
                        Text(
                          "$almostOutOfStock",
                          style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.primaryMain),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          "Stok Akan Habis",
                          style: AppTextStyle.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer loading effect for summary
  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Stok Barang",
                style: AppTextStyle.headline5,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBackgorund,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShimmerBox(),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _buildShimmerBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build shimmer effect
  Widget _buildShimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 20,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 8.0),
          Container(
            width: 80,
            height: 16,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }


}
