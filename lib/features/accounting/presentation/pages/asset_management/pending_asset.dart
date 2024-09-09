import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/pending_asset_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/pending_asset_cubit.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PendingAssetPage extends StatefulWidget {
  const PendingAssetPage({Key? key}) : super(key: key);

  @override
  State<PendingAssetPage> createState() => _PendingAssetPageState();
}

class _PendingAssetPageState extends State<PendingAssetPage> {
  late final AuthSharedPref _authSharedPref;
  late final int branchId;
  late final int companyId;

  @override
  void initState() {
    _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;

    _fetchPendingAssets();
    super.initState();
  }

  void _fetchPendingAssets() {
    context.read<PendingAssetCubit>().fetchPendingAssets(
          branchId: branchId,
          companyId: companyId,
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
          'Asset Tertunda',
          style: AppTextStyle.headline5,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchPendingAssets(); // Ketika di-refresh, panggil lagi API
        },
        child: BlocBuilder<PendingAssetCubit, PendingAssetState>(
          builder: (context, state) {
            if (state is PendingAssetLoading) {
              return _buildLoadingShimmer();
            } else if (state is PendingAssetError) {
              return Center(child: Text(state.message));
            } else if (state is PendingAssetLoaded) {
              return _buildPendingAssetList(state.pendingAssets);
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



  // Widget untuk menampilkan list Pending Asset
  Widget _buildPendingAssetList(List<PendingAssetModel> assets) {
    return ListView.builder(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return _buildPendingAssetCard(asset);
      },
    );
  }

  // Widget untuk menampilkan kartu Pending Asset
  Widget _buildPendingAssetCard(PendingAssetModel asset) {
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
                _buildItemColumn("Barang", asset.itemName),
                const SizedBox(height: 8),
                _buildItemColumn("Faktur", asset.invoiceNumber),
                const SizedBox(height: 16),
                _buildCostRow("Biaya Akuisisi", asset.acquisitionCost),
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
          bottomRight: Radius.circular(10)
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
  Widget _buildItemColumn(String title, String value) {
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

  // Widget untuk biaya akuisisi
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
              style:
                  AppTextStyle.caption.copyWith(color: AppColors.textGrey800),
            ),
            Text(
              Utils.formatCurrencyDouble(value),
              style:
                  AppTextStyle.bigCaptionBold.copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}
