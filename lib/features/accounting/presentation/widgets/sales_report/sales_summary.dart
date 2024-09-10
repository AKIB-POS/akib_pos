import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/sales_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/transaction_report_item.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesSummary extends StatelessWidget {
  const SalesSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          return Center(child: Text(state.message));
        } else {
          return Container();
        }
      },
    );
  }
}
