import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/accounting_transaction_reporrt_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_list_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_interaction_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/shimmer_widget.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/accounting_transaction_customer_card.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';


class CustomerTransaction extends StatelessWidget {
  CustomerTransaction({super.key});
   
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  Widget build(BuildContext context) {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    final companyId = _authSharedPref.getCompanyId() ?? 0;
    final transactionListCubit = context.read<TransactionListCubit>();

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Transaksi Pelanggan",
              style: AppTextStyle.headline5,
            ),
          ),
          Row(
            children: [
              _buildChip(
                context,
                title: "Top 10",
                type: CustomerTransactionType.top10,
                cubit: transactionListCubit,
                branchId: branchId,
                companyId: companyId,
              ),
              const SizedBox(width: 8),
              _buildChip(
                context,
                title: "Diskon Pelanggan",
                type: CustomerTransactionType.discount,
                cubit: transactionListCubit,
                branchId: branchId,
                companyId: companyId,
              ),
            ],
          ),
          BlocBuilder<TransactionListCubit, TransactionReportState>(
            builder: (context, state) {
              if (state is TransactionReportLoading) {
                return _buildShimmerList();
              } else if (state is TransactionReportError) {
                return Center(child: Text(state.message));
              } else if (state is Top10TransactionsSuccess || state is DiscountTransactionsSuccess) {
                final transactions = state is Top10TransactionsSuccess ? state.transactions : (state as DiscountTransactionsSuccess).transactions;
                return _buildTransactionList(transactions);
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context,
      {required String title, required CustomerTransactionType type, required TransactionListCubit cubit, required int branchId, required int companyId}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final interactionCubit = context.read<TransactionReportInteractionCubit>();
          interactionCubit.selectTransactionType(type);
          final state = interactionCubit.state;

          if (type == CustomerTransactionType.top10) {
            cubit.fetchTop10Transactions(
              branchId: branchId,
              companyId: companyId,
              employeeId: state.employeeId,
              date: state.selectedDate,
            );
          } else {
            cubit.fetchDiscountTransactions(
              branchId: branchId,
              companyId: companyId,
              employeeId: state.employeeId,
              date: state.selectedDate,
            );
          }
        },
        child: BlocBuilder<TransactionReportInteractionCubit, TransactionReportInteractionState>(
          builder: (context, state) {
            final isSelected = state.selectedTransactionType == type;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBackgorund : Colors.white,
                border: isSelected
                    ? Border.all(color: AppColors.primaryMain)
                    : Border.all(color: AppColors.textGrey300),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryMain : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<AccountingTransactionReportModel> transactions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return AccountingTransactionCustomerCard(transaction: transaction);
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Simulate 5 shimmer items
      itemBuilder: (context, index) {
        return  ShimmerWidget.rectangular(
          width: double.infinity,
          height: 10.h, // Adjust this to match your card height
        );
      },
    );
  }
}