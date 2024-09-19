import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/accounting/data/datasources/local/employee_shared_pref.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/transaction_list_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/transaction_report_interaction_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/customer_transaction.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/summary_transaction.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/transaction_report_top.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/transaction_report/transaction_report_item.dart';
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

  @override
  void initState() {
    super.initState();
    _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;

    _loadInitialData();
  }

  void _loadInitialData() {
    final interactionCubit = context.read<TransactionReportInteractionCubit>();
    _fetchTodayTransactionReport(interactionCubit.state);
    _fetchCustomerTransactions(interactionCubit.state);
  }

  void _fetchTodayTransactionReport(TransactionReportInteractionState state) {
    context.read<TransactionReportCubit>().fetchTodayTransactionReport(
          branchId: branchId,
          companyId: companyId,
          employeeId: state.employeeId,
          date: state.selectedDate,
        );
  }

  void _fetchCustomerTransactions(TransactionReportInteractionState state) {
    if (state.selectedTransactionType == CustomerTransactionType.top10) {
      context.read<TransactionListCubit>().fetchTop10Transactions(
            branchId: branchId,
            companyId: companyId,
            employeeId: state.employeeId,
            date: state.selectedDate,
          );
    } else {
      context.read<TransactionListCubit>().fetchDiscountTransactions(
            branchId: branchId,
            companyId: companyId,
            employeeId: state.employeeId,
            date: state.selectedDate,
          );
    }
  }

  Future<void> _refreshData() async {
    final interactionCubit = context.read<TransactionReportInteractionCubit>();
    _fetchTodayTransactionReport(interactionCubit.state);
    _fetchCustomerTransactions(interactionCubit.state);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    await showDialog(
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
              child: Column(
                children: [
                  Expanded(
                    child: CalendarDatePicker(
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
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
                  final interactionCubit =
                      context.read<TransactionReportInteractionCubit>();
                  interactionCubit.selectDate(selectedDate);
                  _fetchTodayTransactionReport(interactionCubit.state);
                  _fetchCustomerTransactions(interactionCubit.state);
                  Navigator.of(context).pop();
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
                    color: AppColors.textGrey300,
                  ),
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
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      return RadioListTile<String>(
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
                      );
                    },
                  ),
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
                        _fetchTodayTransactionReport(cubit.state);
                        _fetchCustomerTransactions(cubit.state);
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
              TransactionReportTop(
                onDateTap: () => _selectDate(context),
                onEmployeeTap: () => showEmployeePicker(context),
              ),
              const SummaryTransaction(),
               CustomerTransaction(),
            ],
          ),
        ),
      ),
    );
  }
}
