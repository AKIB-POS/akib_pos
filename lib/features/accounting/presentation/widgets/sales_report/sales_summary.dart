import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/date_range_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/sales_product_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/sales_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/transaction_report_item.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SalesSummary extends StatelessWidget {
   SalesSummary({Key? key}) : super(key: key);
    late final AuthSharedPref _authSharedPref;
  late final int branchId;
  late final int companyId;
  DateTime? customStartDate = DateTime.now();
  DateTime? customEndDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
     _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;

    void _fetchSalesReport() {
    final dateRange = context
        .read<DateRangeCubit>()
        .state; // Dapatkan rentang tanggal dari cubit

    // Gunakan startDate dan endDate untuk memanggil cubit
    context.read<SalesReportCubit>().fetchSalesReport(
          branchId: branchId,
          companyId: companyId,
          date: dateRange, // Gunakan tanggal awal
        );
  }
    return BlocBuilder<SalesReportCubit, SalesReportState>(
      builder: (context, state) {
        if (state is SalesReportLoading) {
          return Container(
            color: AppColors.backgroundGrey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Total Penjualan',
                          isLoading: true, // Loading shimmer
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Total HPP',
                          isLoading: true, // Loading shimmer
                        ),
                      ),
                    ],
                  ),
                ),
                
              ],
              
            ),
          );
        } else if (state is SalesReportSuccess) {
          return Container(
            color: AppColors.backgroundGrey,
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Total Penjualan',
                          amount: Utils.formatCurrencyDouble(state.report.totalSales),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Total HPP',
                          amount: Utils.formatCurrencyDouble(state.report.totalCostOfGoodsSold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                ),
              ],
            ),
          );
        } else if (state is SalesReportError) {
          return Utils.buildErrorStatePlain(title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            _fetchSalesReport();
          },);
        } else {
          return Container();
        }
      },
    );
  }
}
