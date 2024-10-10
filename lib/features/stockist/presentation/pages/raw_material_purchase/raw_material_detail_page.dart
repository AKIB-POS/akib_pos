import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material/material_detail.dart';
import 'package:akib_pos/features/stockist/data/models/purchase_history.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_raw_material_purchase_history_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/material_detail_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/pages/raw_material_purchase/add_raw_material_stock_page.dart';
import 'package:akib_pos/features/stockist/presentation/widgets/appbar_stockist_content.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RawMaterialDetailPage extends StatefulWidget {
  final int materialId;

  const RawMaterialDetailPage({Key? key, required this.materialId})
      : super(key: key);

  @override
  _RawMaterialDetailPageState createState() => _RawMaterialDetailPageState();
}

class _RawMaterialDetailPageState extends State<RawMaterialDetailPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchMaterialDetail();
    _fetchRawMaterialPurchaseHistory();
  }

  Future<void> _fetchMaterialDetail() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<GetMaterialDetailCubit>().fetchMaterialDetail(
          branchId: branchId,
          materialId: widget.materialId,
        );
  }

  Future<void> _fetchRawMaterialPurchaseHistory() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<GetRawMaterialPurchaseHistoryCubit>().fetchRawMaterialPurchaseHistory(
          branchId: branchId,
          materialId: widget.materialId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Detail bahan', style: AppTextStyle.headline5),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titleSpacing: 0,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: RefreshIndicator(
          color: AppColors.primaryMain,
          onRefresh: () async {
            await _fetchMaterialDetail();
            await _fetchRawMaterialPurchaseHistory();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<GetMaterialDetailCubit, GetMaterialDetailState>(
                  builder: (context, state) {
                    if (state is GetMaterialDetailLoading) {
                      return Utils.buildLoadingCardShimmer();
                    } else if (state is GetMaterialDetailError) {
                      return Utils.buildErrorStatePlain(
                        title: 'Gagal Memuat Data Material',
                        message: state.message,
                        onRetry: _fetchMaterialDetail,
                      );
                    } else if (state is GetMaterialDetailLoaded) {
                      return Container(
                          color: AppColors.backgroundGrey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: _buildMaterialDetailContent(
                                    state.materialDetail),
                              ),
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
                          ));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 21, left: 16),
                  child:
                      Text('Riwayat Pembelian', style: AppTextStyle.headline5),
                ),
                BlocBuilder<GetRawMaterialPurchaseHistoryCubit, GetRawMaterialPurchaseHistoryState>(
                  builder: (context, state) {
                    if (state is GetRawMaterialPurchaseHistoryLoading) {
                      return _buildLoadingShimmer();
                    } else if (state is GetRawMaterialPurchaseHistoryError) {
                      return Utils.buildErrorStatePlain(
                        title: 'Gagal Memuat Riwayat Pembelian',
                        message: state.message,
                        onRetry: _fetchRawMaterialPurchaseHistory,
                      );
                    } else if (state is GetRawMaterialPurchaseHistoryLoaded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildRawMaterialPurchaseHistoryList(
                            state.RawMaterialpurchaseHistoryResponse.purchaseHistories),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        );
  }

  Widget _buildMaterialDetailContent(MaterialDetailResponse materialDetail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Material name and code container
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                materialDetail.materialName,
                style: AppTextStyle.bigCaptionBold
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                materialDetail.materialCode,
                style: AppTextStyle.bigCaptionBold
                    .copyWith(color: AppColors.textGrey600),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quantity and average price container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryMain,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jumlah & Satuan',
                      style: AppTextStyle.caption.copyWith(color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        materialDetail.quantity,
                        style: AppTextStyle.bigCaptionBold.copyWith(
                            color: AppColors.primaryMain,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Row 2: Average Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Harga Rata-rata',
                      style: AppTextStyle.caption.copyWith(color: Colors.white),
                    ),
                    Text(
                      Utils.formatCurrencyDouble(materialDetail.averagePrice),
                      style: AppTextStyle.bigCaptionBold.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRawMaterialPurchaseHistoryList(List<RawMaterialPurchaseHistory> purchases) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: purchases
            .map((purchase) => _buildRawMaterialPurchaseHistoryCard(purchase))
            .toList(),
      ),
    );
  }

  Widget _buildRawMaterialPurchaseHistoryCard(RawMaterialPurchaseHistory purchase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(purchase.purchaseDate),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(purchase.purchaseName),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primaryMain.withOpacity(0.1),
                        ),
                        child: Text(
                          purchase.quantity,
                          style: AppTextStyle.bigCaptionBold
                              .copyWith(color: AppColors.primaryMain),
                        )),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.textGrey100,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildItemRow('Vendor', purchase.vendor),
                      const SizedBox(height: 8),
                      _buildItemRow(
                          'Tanggal Kedaluwarsa', purchase.expirationDate),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Harga Beli", style: AppTextStyle.caption),
                          Text(
                              Utils.formatCurrencyDouble(
                                  purchase.purchasePrice),
                              style: AppTextStyle.bigCaptionBold),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildItemRow('Status Pesanan', purchase.orderStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Text(
        date,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildItemRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: AppTextStyle.caption.copyWith(color: AppColors.textGrey600)),
        Text(value, style: AppTextStyle.caption),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Utils.buildLoadingCardShimmer();
      },
    );
  }

}
