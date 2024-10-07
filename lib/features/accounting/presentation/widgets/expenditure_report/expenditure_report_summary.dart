import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/date_range_expenditure_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/total_expenditure_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/transaction_report_item.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ExpenditureReportSummary extends StatelessWidget {
   ExpenditureReportSummary({Key? key}) : super(key: key);
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
    void _fetchTotalExpenditure() {
    final dateRange = context.read<DateRangeExpenditureCubit>().state; // Dapatkan rentang tanggal dari cubit

    context.read<TotalExpenditureCubit>().fetchTotalExpenditure(
          branchId: branchId,
          companyId: companyId,
          date: dateRange, // Gunakan tanggal dari rentang yang dipilih
        );
  }
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
          return Utils.buildErrorStatePlain(title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            _fetchTotalExpenditure();
          },);
        } else {
          return Container();
        }
      },
    );
  }
}
