import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/total_purchase_model.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/transaction_report_item.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchasingReportSummary extends StatelessWidget {
  const PurchasingReportSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotalPurchaseCubit, TotalPurchaseState>(
      builder: (context, state) {
        if (state is TotalPurchaseLoading) {
          return Container(
            color: AppColors.backgroundGrey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Total Pembelian',
                          isLoading: true, // Shimmer loading
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is TotalPurchaseSuccess) {
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
                          title: 'Total Pembelian',
                          amount: Utils.formatCurrencyDouble(state.totalPurchase.totalPurchase),
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
        } else if (state is TotalPurchaseError) {
           return Utils.buildEmptyStatePlain(state.message,
                      "Silahkan Swipe Kebawah\nUntuk Memuat Ulang");
        } else {
          return Container();
        }
      },
    );
  }
}
