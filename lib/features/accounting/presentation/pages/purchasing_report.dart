import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/date_range_pruchase_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/purchase_list_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/total_purchase_model.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/purchasing_report/purchase_list_card.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/purchasing_report/purchasing_report_summary.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/purchasing_report/purchasing_report_top.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class PurchasingReport extends StatefulWidget {
  const PurchasingReport({super.key});

  @override
  State<PurchasingReport> createState() => _PurchasingReportState();
}

class _PurchasingReportState extends State<PurchasingReport> {
  late final AuthSharedPref _authSharedPref;
  late final int branchId;
  late final int companyId;
  DateTime? customStartDate = DateTime.now();
  DateTime? customEndDate = DateTime.now();

  @override
  void initState() {
    _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;

    _fetchTotalPurchase();
    _fetchPurchaseList();
    super.initState();
  }

  void _fetchTotalPurchase() {
    final dateRange = context.read<DateRangePurchaseCubit>().state; // Dapatkan rentang tanggal dari cubit

    context.read<TotalPurchaseCubit>().fetchTotalPurchase(
          branchId: branchId,
          companyId: companyId,
          date: dateRange, // Gunakan tanggal dari rentang yang dipilih
        );
  }
  void _fetchPurchaseList() {
    final dateRange = context.read<DateRangePurchaseCubit>().state; // Dapatkan rentang tanggal dari cubit

    context.read<PurchaseListCubit>().fetchTotalPurchaseList(
          branchId: branchId,
          companyId: companyId,
          date: dateRange, // Gunakan tanggal dari rentang yang dipilih
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: () async {
          _fetchTotalPurchase();
          _fetchPurchaseList();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PurchasingReportTop(
                onDateTap: () => _selectDate(context),
              ),
              const PurchasingReportSummary(),
              const Padding(
                padding: EdgeInsets.only(left: 16,bottom: 16),
                child: Text("Laporan Pembelian",style: AppTextStyle.headline5,),
              ),
              PurchaseListCard()
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final cubit = context.read<DateRangePurchaseCubit>();
            DateRangeOption tempSelectedOption = cubit.selectedOption;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 8,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.textGrey300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (var option in DateRangeOption.values)
                    RadioListTile<DateRangeOption>(
                      title: Text(_getOptionTitle(option)),
                      value: option,
                      groupValue: tempSelectedOption,
                      activeColor: AppColors.primaryMain,
                      contentPadding: const EdgeInsets.only(left: 0),
                      onChanged: (DateRangeOption? value) {
                        setState(() {
                          tempSelectedOption = value!;
                          cubit.selectedOption = value;
                        });
                      },
                    ),
                  const SizedBox(height: 16),
                  if (tempSelectedOption != DateRangeOption.custom ||
                      customStartDate != null && customEndDate != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryMain,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          if (tempSelectedOption == DateRangeOption.today) {
                            cubit.selectToday();
                          } else if (tempSelectedOption == DateRangeOption.last7Days) {
                            cubit.selectLast7Days();
                          } else if (tempSelectedOption == DateRangeOption.last30Days) {
                            cubit.selectLast30Days();
                          } else if (tempSelectedOption == DateRangeOption.custom) {
                            if (customStartDate != null && customEndDate != null) {
                              cubit.selectCustomRange(customStartDate!, customEndDate!);
                            }
                          }

                          // Setelah memilih rentang tanggal, muat ulang data
                          _fetchTotalPurchase();
                        },
                        child: const Text(
                          'Terapkan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getOptionTitle(DateRangeOption option) {
    switch (option) {
      case DateRangeOption.today:
        return 'Hari Ini';
      case DateRangeOption.last7Days:
        return '7 Hari Terakhir';
      case DateRangeOption.last30Days:
        return '30 Hari Terakhir';
      case DateRangeOption.custom:
        return 'Pilih Tanggal Sendiri';
    }
  }
}
