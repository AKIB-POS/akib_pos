import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_recent_purchase.dart';
import 'package:akib_pos/features/stockist/data/models/stockist_summary.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/stockist_recent_purchase_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/stockist_summary_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/widgets/appbar_stockist_content.dart';
import 'package:akib_pos/features/stockist/presentation/widgets/build_stockist_summary.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class StockistPage extends StatefulWidget {
  const StockistPage({Key? key}) : super(key: key);

  @override
  createState() => _StockistPageState();
}

class _StockistPageState extends State<StockistPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    try {
      await Future.wait([
        context.read<StockistSummaryCubit>().fetchStockistSummary(branchId: branchId),
        context.read<StockistRecentPurchasesCubit>().fetchStockistRecentPurchases(branchId: branchId),
      ]);
    } catch (error, stacktrace) {
      // Log the error for debugging purposes
      print('Error fetching data: $error');
      print(stacktrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 1,
          flexibleSpace: SafeArea(child: AppbarStockistContent()),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<StockistSummaryCubit, StockistSummaryState>(
                builder: (context, state) {
                  if (state is StockistSummaryLoading) {
                    return const BuildStockistSummaryLoading();
                  } else if (state is StockistSummaryLoaded) {
                    if (state.stockistSummary != null) {
                      return BuildStockistSummary(summary: state.stockistSummary);
                    } else {
                      return Utils.buildErrorStatePlain(
                        title: "Gagal Memuat",
                        message: "Data Stockist kosong.",
                        onRetry: _fetchData,
                      );
                    }
                  } else if (state is StockistSummaryError) {
                    return Utils.buildErrorStatePlain(
                      title: "Gagal Memuat",
                      message: "Tarik Kebawah Untuk Mengulang",
                      onRetry: _fetchData,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
               Padding(
            padding: const EdgeInsets.only(bottom: 21, left: 16, top: 8),
            child: Text('Pembelian Terbaru', style: AppTextStyle.headline5),
          ),
              BlocBuilder<StockistRecentPurchasesCubit, StockistRecentPurchasesState>(
                builder: (context, state) {
                  if (state is StockistRecentPurchasesLoading) {
                    return Utils.buildLoadingCardShimmer();
                  } else if (state is StockistRecentPurchasesLoaded) {
                    if (state.recentPurchases != null && state.recentPurchases.recentPurchases.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildRecentPurchasesList(state.recentPurchases.recentPurchases),
                      );
                    } else {
                      return Utils.buildEmptyStatePlain(
                        "Belum Ada Pembelian",
                        "Data pembelian terbaru akan muncul setelah Anda melakukan pembelian.",
                      );
                    }
                  } else if (state is StockistRecentPurchasesError) {
                    return Utils.buildErrorStatePlain(
                      title: 'Gagal Memuat Data Pembelian',
                      message: state.message,
                      onRetry: _fetchData,
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

  Widget _buildRecentPurchasesList(List<StockistRecentPurchase> purchases) {
    return Column(
      children: purchases.map((purchase) => _buildPurchaseItem(purchase)).toList(),
    );
  }

  Widget _buildPurchaseItem(StockistRecentPurchase purchase) {
    final itemName = purchase.itemName ?? "Unknown Item";
    final quantity = purchase.quantity ?? "0";
    final vendor = purchase.vendor ?? "Unknown Vendor";
    final price = purchase.purchasePrice ?? 0.0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
          _buildDateHeader(purchase.date ?? "Unknown Date"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        itemName,
                        style: AppTextStyle.headline5,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 2,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryMain.withOpacity(0.1),
                      ),
                      child: Text(
                        quantity,
                        style: AppTextStyle.caption.copyWith(color: AppColors.primaryMain),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildVendorAndPriceColumn(vendor, price),
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
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVendorAndPriceColumn(String vendor, double price) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.textGrey100,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Vendor', style: AppTextStyle.caption),
              const SizedBox(height: 4),
              Text(vendor, style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Harga Beli', style: AppTextStyle.caption),
              const SizedBox(height: 4),
              Text(Utils.formatCurrencyDouble(price),
                  style: AppTextStyle.bigCaptionBold.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

