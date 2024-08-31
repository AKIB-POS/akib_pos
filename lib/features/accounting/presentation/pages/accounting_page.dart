import 'package:akib_pos/common/app_colors.dart';
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
    context.read<TransactionSummaryCubit>().fetchTodayTransactionSummary(
          _authSharedPref.getBranchId() ?? 0,
          _authSharedPref.getCompanyId() ?? 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundGrey,
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h), // Tinggi AppBar ditambah di sini
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false, // Menghilangkan tombol default menu drawer
          backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
          elevation: 0,
          flexibleSpace: SafeArea(
            child: AppBarAccountingContent(),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: ListView(
          children: [
            BlocBuilder<TransactionSummaryCubit, TransactionSummaryState>(
              builder: (context, state) {
                return TodayTransactionSummary(state: state);
              },
            ),
            AccountingGridMenu(),
          ],
        ),
      ),
    );
  }
}

