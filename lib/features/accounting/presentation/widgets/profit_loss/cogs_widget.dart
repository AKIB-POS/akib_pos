import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/profit_loss/profit_loss_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/profit_loss/profit_loss_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class COGSWidget extends StatelessWidget {
  const COGSWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfitLossCubit, ProfitLossState>(
      builder: (context, state) {
        if (state is ProfitLossLoading) {
          return Utils.buildLoadingCardShimmer();
        } else if (state is ProfitLossError) {
          return Center(child: Text(state.message));
        } else if (state is ProfitLossLoaded) {
          return _buildCOGS(state.profitLoss.cogs);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildCOGS(COGS cogs) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Harga Pokok Penjualan", style: AppTextStyle.bigCaptionBold),
          const SizedBox(height: 8),
          _buildRowBold("Total", cogs.totalCogs),
        ],
      ),
    );
  }

  Widget _buildRowBold(String title, double value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
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
