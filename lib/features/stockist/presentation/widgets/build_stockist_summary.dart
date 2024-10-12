import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/stockist/data/models/stock/stockist_summary.dart';
import 'package:akib_pos/features/stockist/presentation/pages/equipment/equipment_purchases_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/equipment/equipment_type_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/expired_stock_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/purchase/raw_material_purchase_page.dart';
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
            child: _buildUiTotalMaterials(summary.totalMaterials,context),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: GestureDetector(
                  onTap: () {
                    Utils.navigateToPage(context, RawMaterialPage());
                  },
                  child: _buildRawMaterialCard())),
                Expanded(child: GestureDetector(
                  onTap: () {
                    Utils.navigateToPage(context, const EquipmentTypePage());
                  },
                  child: _buildEquipmentListCard())),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16,bottom: 16,right: 16,left: 10),
            child: GestureDetector(
                    onTap: () {
                      Utils.navigateToPage(context, const VendorListPage());
                    },
                    child: _buildVendorListCard()),
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

  Widget _buildUiTotalMaterials(int totalMaterials,BuildContext context) {
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
            
          _showMaterialTypeDialog(context);
    
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

  void _showMaterialTypeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(21), topStart: Radius.circular(21)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grey bar at the top center
              Center(
                child: Container(
                  width: 40, // Width of the grey bar
                  height: 4, // Height of the grey bar
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                  height: 16), // Spacing between grey bar and the header
              // Header Row with "Pilih Bahan" and Close Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pilih Tipe Pembelian', style: AppTextStyle.headline5),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ListTile(
                title: const Text('Bahan Baku', style: AppTextStyle.body2),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  Navigator.of(context).pop();
                  Utils.navigateToPage(context, const RawMaterialPurchasesPage());
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Divider(),
              ), // Divider between "Bahan Baku" and "Non Bahan Baku"
              // Second option: "Non Bahan Baku"
              ListTile(
                title: const Text('Peralatan', style: AppTextStyle.body2),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {

                  Navigator.of(context).pop();
                  Utils.navigateToPage(context, EquipmentPurchasesPage());

                },
              ),
              const SizedBox(height: 8), // Spacing after the options
            ],
          ),
        );
      },
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
  Widget _buildEquipmentListCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: _buildVerificationCard(
        null,
        'Jenis\nPeralatan',
        'assets/icons/stockist/ic_equipment.svg',
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