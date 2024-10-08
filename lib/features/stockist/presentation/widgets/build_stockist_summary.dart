import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_summary.dart';
import 'package:akib_pos/features/stockist/presentation/pages/expired_stock_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/raw_material/raw_material_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/running_out_stock_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/vendor/vendor_list_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class BuildStockistSummary extends StatelessWidget {
  final StockistSummaryResponse summary;

  const BuildStockistSummary({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundGrey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildUiTotalMaterials(summary.totalMaterials),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: GestureDetector(
                  onTap: () {
                    Utils.navigateToPage(context, ExpiredStockPage());
                  },
                  child: _buildExpiredStockCard(summary.expiredStockCount))),
                Expanded(child: GestureDetector(
                  onTap: () {
                    Utils.navigateToPage(context, RunningOutStockPage());
                  },
                  child: _buildRunningOutStockCard(summary.runningOutStockCount))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
            child: Row(
              children: [
                Expanded(child: GestureDetector(
                  onTap: () {
                    Utils.navigateToPage(context, RawMaterialPage());
                  },
                  child: _buildRawMaterialCard())),
                Expanded(child: GestureDetector(
                  onTap: () {
                    Utils.navigateToPage(context, const VendorListPage());
                  },
                  child: _buildVendorListCard())),
              ],
            ),
          ),
          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                          ),
        ],
      ),
    );
  }

  Widget _buildUiTotalMaterials(int totalMaterials) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only( top: 21, bottom: 8),
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
          Text("Total Bahan", style: AppTextStyle.caption.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          Text("$totalMaterials", style: AppTextStyle.headline5.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle button press
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            child: Text(
              "Lihat Pembelian",
              style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.primaryMain),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredStockCard(int expiredStockCount) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: _buildVerificationCard(
        expiredStockCount,
        'Stok\nKedaluarsa',
        'assets/icons/stockist/ic_expired_stock.svg',
      ),
    );
  }

  Widget _buildRunningOutStockCard(int runningOutStockCount) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: _buildVerificationCard(
        runningOutStockCount,
        'Stok\nAkan Habis',
        'assets/icons/stockist/ic_stock_will_run_out.svg',
      ),
    );
  }

  Widget _buildRawMaterialCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: _buildVerificationCard(
        null,
        'Bahan\nBaku',
        'assets/icons/stockist/ic_raw_material.svg',
      ),
    );
  }

  Widget _buildVendorListCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: _buildVerificationCard(
        null,
        'Daftar\nVendor',
        'assets/icons/stockist/ic_list_on_vendor.svg',
      ),
    );
  }

  Widget _buildVerificationCard(int? total, String label, String assetPath) {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (total != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.primaryBackgorund,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    total.toString(),
                    style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.primaryMain),
                  ),
                ),
              const SizedBox(height: 4),
              Text(label, style: AppTextStyle.bigCaptionBold),
            ],
          ),
          SvgPicture.asset(assetPath, height: 40, width: 40),
        ],
      ),
    );
  }
}

class BuildStockistSummaryLoading extends StatelessWidget {
  const BuildStockistSummaryLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            child: _buildShimmerBox(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: _buildShimmerBox()),
                const SizedBox(width: 8),
                Expanded(child: _buildShimmerBox()),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: _buildShimmerBox()),
                const SizedBox(width: 8),
                Expanded(child: _buildShimmerBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}