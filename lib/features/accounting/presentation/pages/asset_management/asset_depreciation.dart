import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/asset_management/asset_depreciation_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/asset_depreciation_cubit.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AssetDepreciationPage extends StatefulWidget {
  const AssetDepreciationPage({Key? key}) : super(key: key);

  @override
  State<AssetDepreciationPage> createState() => _AssetDepreciationPageState();
}

class _AssetDepreciationPageState extends State<AssetDepreciationPage> {
  late final AuthSharedPref _authSharedPref;
  late final int branchId;
  late final int companyId;

  @override
  void initState() {
    _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;

    _fetchAssetDepreciation();
    super.initState();
  }

  void _fetchAssetDepreciation() {
    context.read<AssetDepreciationCubit>().fetchAssetsDepreciation(
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
          'Penyusutan Aset',
          style: AppTextStyle.headline5,
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: () async {
          _fetchAssetDepreciation(); // Refresh data ketika di-refresh
        },
        child: BlocBuilder<AssetDepreciationCubit, AssetDepreciationState>(
          builder: (context, state) {
            if (state is AssetsDepreciationLoading) {
              return _buildLoadingShimmer();
            } else if (state is AssetsDepreciationError) {
              return Center(child: Text(state.message));
            } else if (state is AssetsDepreciationLoaded) {
              return _buildAssetDepreciationList(state.depreciations);
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

  // Widget untuk menampilkan list Asset Depreciation
  Widget _buildAssetDepreciationList(List<AssetsDepreciationModel> assets) {
    return ListView.builder(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return _buildAssetDepreciationCard(asset);
      },
    );
  }

  // Widget untuk menampilkan kartu Asset Depreciation
  Widget _buildAssetDepreciationCard(AssetsDepreciationModel asset) {
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
          _buildDateHeader(asset.dateRange),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildItemRow("Detail Aset", "${asset.invoiceNumber} ${asset.assetName}"),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.textGrey200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    
                    children: [
                      _buildCostRow("Masa Manfaat", asset.usefulLife),
                  const SizedBox(height: 8),
                  _buildCostRow("Nilai/Tahun", (asset.valuePerYear * 100).toStringAsFixed(0) + "%"),
                  const SizedBox(height: 8),
                  _buildCostRow("Akumulasi Penyusutan", Utils.formatCurrencyDouble(asset.accumulatedDepreciation)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk header date_range
  Widget _buildDateHeader(String dateRange) {
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
        dateRange,  // Date range seperti yang diinstruksikan
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget untuk baris item (Detail Aset)
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

  // Widget untuk menampilkan informasi biaya seperti masa manfaat, nilai/tahun, dan akumulasi penyusutan
  Widget _buildCostRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.caption.copyWith(color: AppColors.textGrey800),
        ),
        Text(
          value,
          style: AppTextStyle.bigCaptionBold.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
