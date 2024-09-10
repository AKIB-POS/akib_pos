import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/profit_loss/profit_loss_details_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
  class ProfitLossDetailsWidget extends StatelessWidget {
  final double totalSales;
  final double totalCOGS;
  final double totalOperatingExpenses;

  const ProfitLossDetailsWidget({
    Key? key,
    required this.totalSales,
    required this.totalCOGS,
    required this.totalOperatingExpenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalGrossProfit = totalSales - totalCOGS;
    final netProfit = totalGrossProfit - totalOperatingExpenses;

    return BlocBuilder<ProfitLossDetailsCubit, ProfitLossDetailsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian detail yang muncul ke atas
            Visibility(
              visible: state.isDetailsVisible,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.textGrey300.withOpacity(0.8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                  child: Column(
                    children: [
                      _buildRow('Pendapatan dari Penjualan', totalSales),
                      _buildRow('Harga Pokok Penjualan', totalCOGS),
                      const Divider(),
                      _buildRow('Total Laba Kotor', totalGrossProfit),
                      _buildRow('Beban Operasional', totalOperatingExpenses),
                      const Divider(),
                      _buildRow('Total Keuntungan', netProfit),
                    ],
                  ),
                ),
              ),
            ),
            // Bagian Laba Bersih (Selalu di Bawah)
            GestureDetector(
              onTap: () {
                context.read<ProfitLossDetailsCubit>().toggleDetailsVisibility();
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Laba Bersih',
                          style: AppTextStyle.bigCaptionBold,
                        ),
                        Icon(
                          state.isDetailsVisible
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      Utils.formatCurrencyDouble(netProfit),
                      style: AppTextStyle.bigCaptionBold.copyWith(
                        color: AppColors.primaryMain,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.body3),
          Text(Utils.formatCurrencyDouble(value), style: AppTextStyle.body3),
        ],
      ),
    );
  }

  Widget _buildRowBold(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.bigCaptionBold),
          Text(Utils.formatCurrencyDouble(value), style: AppTextStyle.bigCaptionBold),
        ],
      ),
    );
  }
}
