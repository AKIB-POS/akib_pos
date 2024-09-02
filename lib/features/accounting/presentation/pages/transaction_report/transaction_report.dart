import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/accounting/data/datasources/local/employee_shared_pref.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_interaction_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report_item.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class TransactionReport extends StatefulWidget {
  @override
  _TransactionReportState createState() => _TransactionReportState();
}

class _TransactionReportState extends State<TransactionReport> {
  late final AuthSharedPref _authSharedPref;
  late final int branchId;
  late final int companyId;


  getData(){
    _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;

    // Trigger the initial data fetch
    final interactionCubit = context.read<TransactionReportInteractionCubit>();
    context.read<TransactionReportCubit>().fetchTodayTransactionReport(
          branchId: branchId,
          companyId: companyId,
          employeeId: interactionCubit.state.employeeId,
          date: interactionCubit.state.selectedDate,
        );
  }
  
  @override
  void initState() {
    super.initState();
    _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;

    // Trigger the initial data fetch
    final interactionCubit = context.read<TransactionReportInteractionCubit>();
    context.read<TransactionReportCubit>().fetchTodayTransactionReport(
          branchId: branchId,
          companyId: companyId,
          employeeId: interactionCubit.state.employeeId,
          date: interactionCubit.state.selectedDate,
        );
  }

 Future<void> _refreshData() async {
    // Refresh the data
    final interactionCubit = context.read<TransactionReportInteractionCubit>();
     context.read<TransactionReportCubit>().fetchTodayTransactionReport(
          branchId: branchId,
          companyId: companyId,
          employeeId: interactionCubit.state.employeeId,
          date: interactionCubit.state.selectedDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    appBar(context),
                    nameDate(context),
                  ],
                ),
              ),
              summary(context),
              customerTransaction(context),
            ],
          ),
        ),
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
                onTap: () => showEmployeePicker(context),
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
                onTap: () => _selectDate(context),
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

  Widget summary(BuildContext context) {
    return BlocBuilder<TransactionReportCubit, TransactionReportState>(
      builder: (context, state) {
        if (state is TransactionReportLoading) {
          return CircularProgressIndicator(); // Ganti dengan shimmer loading jika perlu
        } else if (state is TransactionReportSuccess) {
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

  Widget customerTransaction(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
              ),
              const SizedBox(width: 8),
              _buildChip(
                context,
                title: "Diskon Pelanggan",
                type: CustomerTransactionType.discount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context,
      {required String title, required CustomerTransactionType type}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context
              .read<TransactionReportInteractionCubit>()
              .selectTransactionType(type);
        },
        child: BlocBuilder<TransactionReportInteractionCubit,
            TransactionReportInteractionState>(
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

  totalCash(double totalCash) {
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

Future<void> _selectDate(BuildContext context) async {
  DateTime selectedDate = DateTime.now();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryMain, // Mengubah warna elemen terpilih
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
            height: 300, // Menetapkan tinggi spesifik untuk CalendarDatePicker
            child: Column(
              children: [
                Expanded(
                  child: CalendarDatePicker(
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (DateTime date) {
                      selectedDate = date;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Gaya untuk tombol "Batal"

              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without any action
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMain, // Gaya untuk tombol "OK"
                foregroundColor: Colors.white
              ),
              onPressed: () {
                final interactionCubit =
                    context.read<TransactionReportInteractionCubit>();
                interactionCubit.selectDate(selectedDate);
                // Trigger fetching data with the new date
                context.read<TransactionReportCubit>().fetchTodayTransactionReport(
                      branchId: branchId,
                      companyId: companyId,
                      employeeId: interactionCubit.state.employeeId,
                      date: interactionCubit.state.selectedDate,
                    );
                Navigator.of(context).pop(); // Close the dialog and save the date
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    },
  );
}




  void showEmployeePicker(BuildContext context) async {
    final cubit = context.read<TransactionReportInteractionCubit>();
    final employees = cubit.getEmployeeList();
    String? tempSelectedEmployee = cubit.state.employeeName;

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
                        color: AppColors.textGrey300),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih Karyawan',
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
                  for (var employee in employees)
                    RadioListTile<String>(
                      title: Text(employee.employeeName),
                      value: employee.employeeName,
                      groupValue: tempSelectedEmployee,
                      dense: true,
                      activeColor: AppColors.primaryMain,
                      toggleable: true,
                      contentPadding: const EdgeInsets.only(left: 0),
                      visualDensity: VisualDensity.compact,
                      onChanged: (String? value) {
                        setState(() {
                          tempSelectedEmployee = value ?? tempSelectedEmployee;
                        });
                      },
                    ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll<Color>(
                            AppColors.primaryMain),
                        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 16),
                        ),
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (tempSelectedEmployee != null) {
                          cubit.selectEmployee(tempSelectedEmployee!);
                          // Trigger fetching data with the new employee
                          context.read<TransactionReportCubit>().fetchTodayTransactionReport(
                                branchId: branchId,
                                companyId: companyId,
                                employeeId: cubit.state.employeeId,
                                date: cubit.state.selectedDate,
                              );
                        }
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

  AppBar appBar(BuildContext context) {
    return AppBar(
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
    );
  }
}
