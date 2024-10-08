import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/active_asset_cubit.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/active_asset_model.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ActiveAssetPage extends StatefulWidget {
  const ActiveAssetPage({Key? key}) : super(key: key);

  @override
  State<ActiveAssetPage> createState() => _ActiveAssetPageState();
}

class _ActiveAssetPageState extends State<ActiveAssetPage> {
  late final AuthSharedPref _authSharedPref;
  late final int branchId;
  late final int companyId;

  @override
  void initState() {
    _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;

    _fetchActiveAssets();
    super.initState();
  }

  void _fetchActiveAssets() {
    context.read<ActiveAssetCubit>().fetchActiveAssets(
          branchId,
          companyId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Asset Aktif',
          style: AppTextStyle.headline5,
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: () async {
          _fetchActiveAssets(); // Refresh data ketika di-refresh
        },
        child: BlocBuilder<ActiveAssetCubit, ActiveAssetState>(
          builder: (context, state) {
            if (state is ActiveAssetLoading) {
              return _buildLoadingShimmer();
            } else if (state is ActiveAssetError) {
              return Utils.buildErrorStatePlain(title: "Gagal Mendapatkan data", message: state.message, onRetry: () {
                _fetchActiveAssets();
              },);
            } else if (state is ActiveAssetLoaded) {
              if (state.activeAssets.isEmpty){
                Utils.buildEmptyState("Belum Ada Aset", "");
              }
              return _buildActiveAssetList(state.activeAssets);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  // Widget untuk menampilkan loading shimmer
   Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Utils.buildLoadingCardShimmer();
      },
    );
  }

  // Widget untuk menampilkan list Active Asset
  Widget _buildActiveAssetList(List<ActiveAssetModel> assets) {
    return ListView.builder(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return _buildActiveAssetCard(asset);
      },
    );
  }

  // Widget untuk menampilkan kartu Active Asset
  Widget _buildActiveAssetCard(ActiveAssetModel asset) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(asset.date),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildItemRow("Detail Aset",
                    "${asset.assetAccountNumber} ${asset.assetName}"),
                const SizedBox(height: 8),
                _buildItemRow("Akun Aset", asset.assetAccountCode),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.textGrey200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      _buildCostRow("Biaya Akumulasi", asset.accumulatedCost),
                      const SizedBox(height: 8),
                      _buildCostRow("Nilai Buku", asset.bookValue),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk header tanggal
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
        DateFormat('dd MMMM yyyy').format(DateTime.parse(date)),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget untuk baris item
  Widget _buildItemRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.caption,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyle.bigCaptionBold,
        ),
      ],
    );
  }

  // Widget untuk menampilkan biaya akumulasi dan nilai buku
  Widget _buildCostRow(String title, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.caption.copyWith(color: AppColors.textGrey800),
        ),
        Text(
          Utils.formatCurrencyDouble(value),
          style: AppTextStyle.bigCaptionBold.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
