import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/financial_balance_report/date_range_financial_balance_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/financial_balance_report/financial_balance_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/financial_balance_report/asset_view.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/financial_balance_report/financial_balance_report_top.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/financial_balance_report/liabilities_and_equity_view.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/financial_balance_report/total_assets_and_liabilities_view.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class FinancialBalanceReport extends StatefulWidget {
  const FinancialBalanceReport({super.key});

  @override
  State<FinancialBalanceReport> createState() => _FinancialBalanceReportState();
}

class _FinancialBalanceReportState extends State<FinancialBalanceReport> {
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
    _fetchFinancialBalanceReport();
    super.initState();
  }

  void _fetchFinancialBalanceReport(){
    final dateRange = context
        .read<DateRangeFinancialBalanceCubit>()
        .state; // Dapatkan rentang tanggal dari cubit

    context.read<FinancialBalanceCubit>().fetchFinancialBalance(
          branchId,
          companyId,
          dateRange, // Gunakan tanggal dari rentang yang dipilih
        );
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.backgroundGrey,
    body: Column(
      children: [
        // Bagian atas yang tidak ikut scroll
        FinancialBalanceReportTop(
          onDateTap: () => _selectDate(context),
        ),

        // Expanded untuk area yang bisa di-scroll
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              _fetchFinancialBalanceReport();
            },
            color: AppColors.primaryMain,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const AssetsView(), // Area yang bisa di-scroll
                  const LiabilitiesAndEquityView(), // Area yang bisa di-scroll
                ],
              ),
            ),
          ),
        ),

        // Bagian bawah yang tetap berada di bawah layar
        const TotalAssetsAndLiabilitiesView(),
      ],
    ),
  );
}

    void _selectDate(BuildContext context) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final cubit = context.read<DateRangeFinancialBalanceCubit>();
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
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih Tanggal',
                          style: AppTextStyle.headline5,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
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
                      onChanged: (DateRangeOption? value) async {
                        setState(() {
                          tempSelectedOption = value!;
                          cubit.selectedOption = value;
                        });

                        if (value == DateRangeOption.custom) {
                          setState(() {
                            customStartDate = DateTime.now();
                            customEndDate = DateTime.now();
                          });
                        }
                      },
                    ),
                  if (tempSelectedOption == DateRangeOption.custom)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: GestureDetector(
                              onTap: () async {
                                final DateTime today = DateTime.now();

                                // Set batasan untuk memilih tanggal
                                final DateTime startDateLastDate = today;

                                // Memanggil dialog untuk memilih tanggal mulai
                                final selectedDate = await _selectCustomDate(
                                    context,
                                    customStartDate!,
                                    DateTime(
                                        2000), // Tanggal pertama yang bisa dipilih
                                    startDateLastDate); // Tanggal terakhir yang bisa dipilih

                                if (selectedDate != null) {
                                  setState(() {
                                    customStartDate = selectedDate;

                                    // Reset customEndDate untuk menyesuaikan dengan customStartDate yang baru dipilih
                                    customEndDate = selectedDate;

                                    // Jika tanggal akhir sebelumnya sebelum tanggal mulai, sesuaikan
                                    if (customEndDate!
                                        .isBefore(customStartDate!)) {
                                      customEndDate = customStartDate;
                                    }
                                  });
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Mulai Dari"),
                                  Text(_formatDate(customStartDate!)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 5,
                            child: GestureDetector(
                              onTap: () async {
                                final DateTime startDate = customStartDate!;
                                final DateTime today = DateTime.now();
                                DateTime endDateFirstDate;
                                DateTime endDateLastDate;

                                // Atur batasan untuk tanggal akhir
                                if (startDate == today) {
                                  endDateFirstDate = startDate;
                                  endDateLastDate = startDate;
                                } else {
                                  endDateFirstDate = startDate;
                                  endDateLastDate = startDate
                                          .add(const Duration(days: 30))
                                          .isAfter(today)
                                      ? today
                                      : startDate.add(const Duration(days: 30));
                                }

                                // Memanggil dialog untuk memilih tanggal akhir
                                final selectedDate = await _selectCustomDate(
                                    context,
                                    customEndDate!,
                                    endDateFirstDate,
                                    endDateLastDate);

                                if (selectedDate != null) {
                                  setState(() {
                                    customEndDate = selectedDate;
                                  });
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Sampai"),
                                  Text(_formatDate(customEndDate!)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          } else if (tempSelectedOption ==
                              DateRangeOption.last7Days) {
                            cubit.selectLast7Days();
                          } else if (tempSelectedOption ==
                              DateRangeOption.last30Days) {
                            cubit.selectLast30Days();
                          } else if (tempSelectedOption ==
                              DateRangeOption.custom) {
                            if (customStartDate != null &&
                                customEndDate != null) {
                              cubit.selectCustomRange(
                                  customStartDate!, customEndDate!);
                            }
                          }

                          // Setelah memilih rentang tanggal, muat ulang data
                          _fetchFinancialBalanceReport();
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

  Future<DateTime?> _selectCustomDate(BuildContext context,
      DateTime initialDate, DateTime firstDate, DateTime lastDate) async {
    DateTime selectedDate = initialDate;

    await showDialog<DateTime?>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryMain,
            ),
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Pilih Tanggal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: firstDate,
                lastDate: lastDate,
                onDateChanged: (DateTime date) {
                  selectedDate = date;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMain,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop(selectedDate);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );

    return selectedDate;
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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