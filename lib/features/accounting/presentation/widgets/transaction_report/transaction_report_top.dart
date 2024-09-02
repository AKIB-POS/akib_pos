import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_interaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class TransactionReportTop extends StatelessWidget {
  final Function onDateTap;
  final Function onEmployeeTap;

  const TransactionReportTop({
    Key? key,
    required this.onDateTap,
    required this.onEmployeeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AppBar(
            forceMaterialTransparency: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            leadingWidth: 20,
            title: const Text(
              'Laporan Transaksi',
              style: AppTextStyle.headline5,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      const Text(
                        'Download',
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        'assets/icons/accounting/ic_download.svg',
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          nameDate(context),
        ],
      ),
    );
  }

  Widget nameDate(BuildContext context) {
    return Container(
      decoration: AppThemes.bottomShadow,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 20),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onEmployeeTap(),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackgorund,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<TransactionReportInteractionCubit, TransactionReportInteractionState>(
                        builder: (context, state) {
                          return Text(
                            state.employeeName,
                            style: const TextStyle(
                              color: AppColors.primaryMain,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      SvgPicture.asset(
                        'assets/icons/accounting/ic_user_square.svg',
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => onDateTap(),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackgorund,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<TransactionReportInteractionCubit, TransactionReportInteractionState>(
                        builder: (context, state) {
                          return Text(
                            state.selectedDate,
                            style: const TextStyle(
                              color: AppColors.primaryMain,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      SvgPicture.asset(
                        'assets/icons/accounting/ic_calendar.svg',
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
