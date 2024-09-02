import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report_item.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryTransaction extends StatelessWidget {
  const SummaryTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionReportCubit, TransactionReportState>(
      builder: (context, state) {
        if (state is TransactionReportLoading) {
          return CircularProgressIndicator(); // Ganti dengan shimmer loading jika perlu
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
                          amount: Utils.formatCurrencyDouble(state.report.openingCash),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Pengeluaran Outlet',
                          amount: Utils.formatCurrencyDouble(state.report.outletExpenses),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Pembayaran\nTunai',
                          amount: Utils.formatCurrencyDouble(state.report.cashPayment),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TransactionReportItem(
                          title: 'Pembayaran\nNon Tunai',
                          amount: Utils.formatCurrencyDouble(state.report.nonCashPayment),
                        ),
                      ),
                    ],
                  ),
                ),
                totalCash(state.report.totalCash),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20), topRight: Radius.circular(10))),
                )
              ],
            ),
          );
        } else if (state is TransactionReportError) {
          return Center(child: Text(state.message));
        } else {
          return Container();
        }
      },
    );
  }

  Widget totalCash(double totalCash) {
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
        Text(
          Utils.formatCurrencyDouble(totalCash),
          style: AppTextStyle.bigCaptionBold.copyWith(color: Colors.white),
        ),
      ]),
    );
  }
}
