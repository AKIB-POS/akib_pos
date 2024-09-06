import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/sold_asset_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/sold_asset_cubit.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class SoldAssetPage extends StatefulWidget {
  const SoldAssetPage({Key? key}) : super(key: key);

  @override
  State<SoldAssetPage> createState() => _SoldAssetPageState();
}

class _SoldAssetPageState extends State<SoldAssetPage> {
  late final AuthSharedPref _authSharedPref;
  late final int branchId;
  late final int companyId;

  @override
  void initState() {
    _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;

    _fetchSoldAssets();
    super.initState();
  }

  void _fetchSoldAssets() {
    context.read<SoldAssetCubit>().fetchSoldAssets(
          branchId : branchId,
          companyId : companyId,
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
          'Dijual/Dilepas',
          style: AppTextStyle.headline5,
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: () async {
          _fetchSoldAssets(); // Refresh data ketika di-refresh
        },
        child: BlocBuilder<SoldAssetCubit, SoldAssetState>(
          builder: (context, state) {
            if (state is SoldAssetLoading) {
              return _buildLoadingShimmer();
            } else if (state is SoldAssetError) {
              return Center(child: Text(state.message));
            } else if (state is SoldAssetLoaded) {
              return _buildSoldAssetList(state.soldAssets);
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
        return _shimmerCard();
      },
    );
  }

  // Widget untuk menampilkan shimmer card
  Widget _shimmerCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan list Sold Asset
  Widget _buildSoldAssetList(List<SoldAssetModel> assets) {
    return ListView.builder(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return _buildSoldAssetCard(asset);
      },
    );
  }

  // Widget untuk menampilkan kartu Sold Asset
  Widget _buildSoldAssetCard(SoldAssetModel asset) {
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
                _buildItemRow("Detail Aset", "(${asset.invoiceNumber}) ${asset.assetDetail}"),
                const SizedBox(height: 8),
                _buildItemRow("No. Transaksi", asset.transactionNumber),
                const SizedBox(height: 16),
                _buildCostRow("Harga Jual", asset.salePrice),
                const SizedBox(height: 8),
                _buildCostRow("Untung/(Rugi)", asset.profitLoss),
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

  // Widget untuk menampilkan harga jual dan untung/(rugi)
  Widget _buildCostRow(String title, double value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.textGrey200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
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
      ),
    );
  }
}
