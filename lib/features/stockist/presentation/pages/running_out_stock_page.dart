import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/running_out_stock.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/running_out_stock_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RunningOutStockPage extends StatefulWidget {
  const RunningOutStockPage({Key? key}) : super(key: key);

  @override
  State<RunningOutStockPage> createState() => _RunningOutStockPageState();
}

class _RunningOutStockPageState extends State<RunningOutStockPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchRunningOutStock();
  }

  Future<void> _fetchRunningOutStock() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    await context.read<RunningOutStockCubit>().fetchRunningOutStock(branchId: branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text('Stok Akan Habis', style: AppTextStyle.headline5),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: _fetchRunningOutStock,
        child: BlocBuilder<RunningOutStockCubit, RunningOutStockState>(
          builder: (context, state) {
            if (state is RunningOutStockLoading) {
              return _buildLoadingList();
            } else if (state is RunningOutStockLoaded) {
              if (state.runningOutStock.runningOutStocks.isEmpty) {
                return Utils.buildEmptyStatePlain(
                  "Tidak Ada Stok Akan Habis",
                  "Tidak ada stok yang akan habis untuk saat ini.",
                );
              } else {
                return _buildRunningOutStockList(state.runningOutStock.runningOutStocks);
              }
            } else if (state is RunningOutStockError) {
              return Utils.buildErrorStatePlain(
                title: "Gagal Memuat Data",
                message: state.message,
                onRetry: _fetchRunningOutStock,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Jumlah item loading simulasi
      itemBuilder: (context, index) {
        return Utils.buildLoadingCardShimmer();
      },
    );
  }

  Widget _buildRunningOutStockList(List<RunningOutStock> runningOutStocks) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: runningOutStocks.length,
      itemBuilder: (context, index) {
        final stock = runningOutStocks[index];
        return _buildRunningOutStockItem(stock);
      },
    );
  }

  Widget _buildRunningOutStockItem(RunningOutStock stock) {
    final itemName = stock.itemName;
    final quantity = stock.quantity;
    final vendor = stock.vendor;

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
      child: Padding(
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
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryMain.withOpacity(0.1),
                  ),
                  child: Text(
                    quantity,
                    style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.primaryMain),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.textGrey100,
      ),child: _buildInfoRow('Vendor', vendor)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.caption),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
