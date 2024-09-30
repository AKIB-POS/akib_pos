import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/hrd_all_employee.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee/hrd_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_service/employee/employee_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HRDEmployeePage extends StatefulWidget {
  const HRDEmployeePage({super.key});

  @override
  _HRDEmployeePageState createState() => _HRDEmployeePageState();
}

class _HRDEmployeePageState extends State<HRDEmployeePage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData(); // Fetch data ketika pertama kali halaman dibangun
  }

  Future<void> _fetchEmployeeData() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<HRDAllEmployeesCubit>().fetchAllEmployees(branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        
        title: const Text('Pegawai', style: AppTextStyle.headline5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchEmployeeData, // Pull-to-refresh action
        child: const HRDEmployeeListWidget(), // Gunakan widget yang sudah digabung
      ),
    );
  }
}
