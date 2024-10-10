import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/equipment_detail.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_detail_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_purchase_history_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/pages/equipment/equipment_purchase_history.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EquipmentDetailPage extends StatefulWidget {
  final int equipmentId;

  const EquipmentDetailPage({Key? key, required this.equipmentId}) : super(key: key);

  @override
  _EquipmentDetailPageState createState() => _EquipmentDetailPageState();
}

class _EquipmentDetailPageState extends State<EquipmentDetailPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchEquipmentDetail();
    _fetchEquipmentPurchaseHistory();
  }

  Future<void> _fetchEquipmentDetail() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<GetEquipmentDetailCubit>().fetchEquipmentDetail(
          branchId: branchId,
          equipmentId: widget.equipmentId,
        );
  }

  Future<void> _fetchEquipmentPurchaseHistory() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<GetEquipmentPurchaseHistoryCubit>().fetchPurchaseHistory(
          branchId: branchId,
          equipmentId: widget.equipmentId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Peralatan', style: AppTextStyle.headline5),
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
          await _fetchEquipmentDetail();
          await _fetchEquipmentPurchaseHistory();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<GetEquipmentDetailCubit, GetEquipmentDetailState>(
                builder: (context, state) {
                  if (state is GetEquipmentDetailLoading) {
                    return Utils.buildLoadingCardShimmer();
                  } else if (state is GetEquipmentDetailError) {
                    return Utils.buildErrorStatePlain(
                      title: 'Gagal Memuat Data Peralatan',
                      message: state.message,
                      onRetry: _fetchEquipmentDetail,
                    );
                  } else if (state is GetEquipmentDetailLoaded) {
                    return Container(
                      color: AppColors.backgroundGrey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildEquipmentDetailContent(state.equipmentDetail),
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
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 21, left: 16),
                child: Text('Riwayat Pembelian', style: AppTextStyle.headline5),
              ),
              BlocBuilder<GetEquipmentPurchaseHistoryCubit, GetEquipmentPurchaseHistoryState>(
                builder: (context, state) {
                  if (state is GetEquipmentPurchaseHistoryLoading) {
                    return _buildLoadingShimmer();
                  } else if (state is GetEquipmentPurchaseHistoryError) {
                    return Utils.buildErrorStatePlain(
                      title: 'Gagal Memuat Riwayat Pembelian',
                      message: state.message,
                      onRetry: _fetchEquipmentPurchaseHistory,
                    );
                  } else if (state is GetEquipmentPurchaseHistoryLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildEquipmentPurchaseHistoryList(
                        state.purchaseHistoryResponse.purchaseHistories,
                      ),
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

  // Widget to build Equipment Detail content
  Widget _buildEquipmentDetailContent(EquipmentDetail equipmentDetail) {
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
          // Equipment name and code
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                equipmentDetail.equipmentName,
                style: AppTextStyle.bigCaptionBold.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                equipmentDetail.equipmentCode,
                style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.textGrey600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quantity and average price
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
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        equipmentDetail.quantity,
                        style: AppTextStyle.bigCaptionBold.copyWith(
                          color: AppColors.primaryMain,
                          fontWeight: FontWeight.bold,
                        ),
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
                      Utils.formatCurrencyDouble(equipmentDetail.averagePrice),
                      style: AppTextStyle.bigCaptionBold.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  // Widget to build Equipment Purchase History List
  Widget _buildEquipmentPurchaseHistoryList(List<EquipmentPurchaseHistory> purchases) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: purchases.map((purchase) => _buildEquipmentPurchaseHistoryCard(purchase)).toList(),
      ),
    );
  }

  // Widget to build individual Equipment Purchase History card
  Widget _buildEquipmentPurchaseHistoryCard(EquipmentPurchaseHistory purchase) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryMain.withOpacity(0.1),
                      ),
                      child: Text(
                        purchase.quantity,
                        style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.primaryMain),
                      ),
                    ),
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
                      _buildItemRow('Vendor', purchase.vendor),
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

  // Widget to build the date header for each card
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
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget to build row for showing key-value items
  Widget _buildItemRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.caption.copyWith(color: AppColors.textGrey600)),
        Text(value, style: AppTextStyle.caption),
      ],
    );
  }

  // Widget to show loading shimmer effect
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
