import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/total_expenditure_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/transaction_report_item.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenditureReportSummary extends StatelessWidget {
  const ExpenditureReportSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotalExpenditureCubit, TotalExpenditureState>(
      builder: (context, state) {
        if (state is TotalExpenditureLoading) {
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
                          title: 'Total Pengeluaran',
                          isLoading: true, // Shimmer loading
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is TotalExpenditureSuccess) {
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
                          title: 'Total Pengeluaran',
                          amount: Utils.formatCurrencyDouble(state.totalExpenditure.totalExpenditure),
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
        } else if (state is TotalExpenditureError) {
          return Center(child: Text(state.message));
        } else {
          return Container();
        }
      },
    );
  }
}
