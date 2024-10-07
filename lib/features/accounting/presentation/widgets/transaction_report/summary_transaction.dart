import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/transaction_report_item.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class SummaryTransaction extends StatelessWidget {
  const SummaryTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionReportCubit, TransactionReportState>(
      builder: (context, state) {
        if (state is TransactionReportLoading) {
          return Container(
            color: AppColors.backgroundGrey,
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TransactionReportItem(
                          title: "Kas Awal",
                          isLoading: true, // Loading shimmer–
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Pengeluaran Outlet',
                          isLoading: true, // Loading shimmer
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Pembayaran\nTunai',
                          isLoading: true, // Loading shimmer
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TransactionReportItem(
                          title: 'PembayaranNon Tunai',
                          isLoading: true, // Loading shimmer
                        ),
                      ),
                    ],
                  ),
                ),
                totalCash(0, isLoading: true), // Aktifkan shimmer
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(10))),
                ),
              ],
            ),
          );
        } else if (state is TodayTransactionReportSuccess) {
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
                          title: 'Kas Awal',
                          amount: Utils.formatCurrencyDouble(
                              state.report.openingCash),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Pengeluaran Outlet',
                          amount: Utils.formatCurrencyDouble(
                              state.report.outletExpenses),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Pembayaran\nTunai',
                          amount: Utils.formatCurrencyDouble(
                              state.report.cashPayment),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Pembayaran\nNon Tunai',
                          amount: Utils.formatCurrencyDouble(
                              state.report.nonCashPayment),
                        ),
                      ),
                    ],
                  ),
                ),
                totalCash(state.report.totalCash),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is TransactionReportError) {
          return Utils.buildEmptyStatePlain("Ada Kesalahan",
            state.message);
        } else {
          return Container();
        }
      },
    );
  }
}

Widget totalCash(double? totalCash, {bool isLoading = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      image: DecorationImage(
        image: ExtendedAssetImageProvider("assets/images/accounting/bg_em.png"),
        fit: BoxFit.fill,
      ),
    ),
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Total Uang Tunai",
        style: AppTextStyle.caption.copyWith(color: Colors.white),
      ),
      const SizedBox(
        height: 10,
      ),
      isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 20,
                width: double.infinity,
                color: Colors.grey,
              ),
            )
          : Text(
              Utils.formatCurrencyDouble(totalCash ?? 0),
              style: AppTextStyle.bigCaptionBold.copyWith(color: Colors.white),
            ),
    ]),
  );
}
