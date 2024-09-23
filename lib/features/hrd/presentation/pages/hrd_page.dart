import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/employee_cubit.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/hrd_summary_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/administration_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/attendance_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/attendance_recap_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/leave_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/overtime_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/permission_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/salary_%20slip_page.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/appbar_hrd_page.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/summary_hrd.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HrdPage extends StatefulWidget {
  const HrdPage({super.key});

  @override
  createState() => _HrdPage();
}

class _HrdPage extends State<HrdPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchHRDSummary();
  }

  void _fetchHRDSummary() {
    final branchId = _authSharedPref.getBranchId() ?? 0;

    // Fetch HRD summary
    context.read<HRDSummaryCubit>().fetchHRDSummary(branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundWhite,
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
          elevation: 0,
          flexibleSpace: SafeArea(
            child: AppbarHrdPage(),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: () async {
          _fetchHRDSummary();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              color: AppColors.backgroundGrey,
              child: Column(
                children: [
                  SummaryHRD(),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _attendanceService(),
            _employeeService(),
          ],
        ),
      ),
    );
  }

  Widget _attendanceService() {
    return Container(
      margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layanan Kehadiran',
            style: AppTextStyle.headline5,
          ),
          const SizedBox(height: 25),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            childAspectRatio: 1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildServiceItem('Absensi', 'assets/icons/hrd/ic_absensi.svg'),
              _buildServiceItem('Cuti', 'assets/icons/hrd/ic_cuti.svg'),
              _buildServiceItem('Lembur', 'assets/icons/hrd/ic_overtime.svg'),
              _buildServiceItem('Izin', 'assets/icons/hrd/ic_permission.svg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _employeeService() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layanan Pegawai',
            style: AppTextStyle.headline5,
          ),
          const SizedBox(height: 25),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            childAspectRatio: 1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              if (_authSharedPref.getEmployeeRole() != "employee")
                _buildServiceItem('Pegawai', 'assets/icons/hrd/ic_employee.svg'),
              _buildServiceItem('Administrasi', 'assets/icons/hrd/ic_administration.svg'),
              _buildServiceItem('Slip Gaji', 'assets/icons/hrd/ic_salary.svg'),
              _buildServiceItem('Tasking', 'assets/icons/hrd/ic_tasking.svg'),
              _buildServiceItem('Pelatihan', 'assets/icons/hrd/ic_training.svg'),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToAttendancePage(BuildContext context) {
    final attendanceData = context.read<HRDSummaryCubit>().state;
    if (attendanceData is HRDSummaryLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AttendancePage(data: attendanceData.hrdSummary),
        ),
      );
    }
  }

  Widget _buildServiceItem(String label, String assetPath) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Absensi':
            _navigateToAttendancePage(context);
            break;
          case 'Cuti':
            Utils.navigateToPage(context, const LeavePage());
            break;
          case 'Izin':
            Utils.navigateToPage(context,  PermissionPage());
            break;
          case 'Lembur':
            Utils.navigateToPage(context, const OvertimePage());
            break;
          case 'Slip Gaji':
            Utils.navigateToPage(context, const SalarySlipPage());
            break;
          case 'Administrasi':
            Utils.navigateToPage(context, const AdministrationPage());
            break;
          default:
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(assetPath),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyle.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
