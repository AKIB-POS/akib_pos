import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/purchase.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_purchase_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/pages/purchase/material_detail_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PurchasesListPage extends StatefulWidget {
  const PurchasesListPage({Key? key}) : super(key: key);

  @override
  _PurchasesListPageState createState() => _PurchasesListPageState();
}

class _PurchasesListPageState extends State<PurchasesListPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchPurchasesData();
  }

  Future<void> _fetchPurchasesData() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<GetPurchasesCubit>().fetchPurchases(branchId: branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Daftar Pembelian',style: AppTextStyle.headline5,),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryMain,
              onRefresh: _fetchPurchasesData,
              child: BlocBuilder<GetPurchasesCubit, GetPurchasesState>(
                builder: (context, state) {
                  if (state is GetPurchasesLoading) {
                    return _buildShimmerLoading();
                  } else if (state is GetPurchasesError) {
                    return Utils.buildErrorState(
                      title: 'Gagal Memuat Data',
                      message: state.message,
                      onRetry: () {
                        _fetchPurchasesData();
                      },
                    );
                  } else if (state is GetPurchasesLoaded) {
                    return state.purchases.purchases.isEmpty
                        ? Utils.buildEmptyState(
                            "Belum ada Pembelian",
                            "Data pembelian akan tampil setelah transaksi.")
                        : _buildPurchasesList(state.purchases.purchases);
                  }
                  return const Center(child: Text('Tidak ada data.'));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) => Utils.buildLoadingCardShimmer(),
    );
  }

  Widget _buildPurchasesList(List<Purchase> purchases) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16,right: 16,bottom: 70),
      itemCount: purchases.length,
      itemBuilder: (context, index) {
        final purchase = purchases[index];
        return _buildPurchaseCard(purchase);
      },
    );
  }

  Widget _buildPurchaseCard(Purchase purchase) {
    Color backgroundColor;
    Color textColor;

    // Set warna sesuai tipe pembelian
    if (purchase.purchaseType == 'Non Bahan Baku') {
      backgroundColor = AppColors.secondaryMain.withOpacity(0.1); // Biru
      textColor = AppColors.secondaryMain;
    } else {
      backgroundColor = AppColors.successMain.withOpacity(0.1); // Hijau
      textColor = AppColors.successMain;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      purchase.purchaseType,
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    purchase.materialName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    purchase.quantity,
                    style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.primaryMain),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  Utils.navigateToPage(context, MaterialDetailPage(materialId: purchase.purchaseId));
                },
                style: AppThemes.outlineButtonPrimaryStyle,
                child: const Text(
                  'Detail',
                  style: TextStyle(color: AppColors.primaryMain),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}