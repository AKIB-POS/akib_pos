import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/accounting/data/models/transaction_report/employee.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/employee_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_summary_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/accounting_grid_menu.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/appbar_accounting_page.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/today_transaction_summary.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

class AccountingPage extends StatefulWidget {
  const AccountingPage({super.key});

  @override
  _AccountingPageState createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    final companyId = _authSharedPref.getCompanyId() ?? 0;

    // Fetch transaction summary
    context.read<TransactionSummaryCubit>().fetchTodayTransactionSummary(
          branchId,
          companyId,
        );

    // Fetch employees
    context.read<EmployeeCubit>().fetchAllEmployees(
          branchId,
          companyId,
        );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Refresh',
          textColor: Colors.white,
          onPressed: _fetchData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundGrey,
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
          elevation: 0,
          flexibleSpace: SafeArea(
            child: AppBarAccountingContent(),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: _fetchData,
        child: ListView(
          children: [
            BlocBuilder<TransactionSummaryCubit, TransactionSummaryState>(
              builder: (context, state) {
                return TodayTransactionSummary(state: state);
              },
            ),
            BlocBuilder<EmployeeCubit, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showErrorSnackbar('Gagal mengambil data pegawai. Silahkan refresh.');
                  });
                  return Container(); // You can return an empty container or any placeholder
                } else if (state is EmployeeLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is EmployeeSuccess) {
                   print("isinyaa ${state.employees}");
                  return SizedBox.shrink();
                } else {
                  return Container(); // Initial state
                }
              },
            ),
            AccountingGridMenu(),
          ],
        ),
      ),
    );
  }

 
}
