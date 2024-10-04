import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/employee_cubit.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/employee_performance.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_training.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_training_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/hrd_subordinate_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/hrd_summary_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/administration_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/attendance_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/attendance_recap_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/employee/hrd_employee_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/employee_performance/employee_performance_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/employee_training_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/attendance_service/leave/leave_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/tasking/employee_tasking_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/tasking/manager_tasking_menu.dart';
import 'package:akib_pos/features/hrd/presentation/pages/attendance_service/overtime/overtime_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/attendance_service/permission/permission_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/salary/salary_%20slip_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/tasking/subordinate_tasking_page.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/appbar_hrd_page.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_service/employee_training_card_widget.dart';
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
  _HrdPageState createState() => _HrdPageState();
}

class _HrdPageState extends State<HrdPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchHRDSummary();
    _fetchAllSubordinateEmployees();
    if (_authSharedPref.getEmployeeRole() == "owner") {
      _fetchEmployeeTrainings();
    }
  }

  void _fetchEmployeeTrainings() {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<EmployeeTrainingCubit>().fetchEmployeeTrainings(branchId: branchId);
  }

  void _fetchHRDSummary() {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<HRDSummaryCubit>().fetchHRDSummary(branchId);
  }

  // Fetch all subordinate employees
  void _fetchAllSubordinateEmployees() {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<HRDAllSubordinateEmployeeCubit>().fetchAllSubordinateEmployees(branchId: branchId);
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = _authSharedPref.getEmployeeRole() == "owner";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundWhite,
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: AppBar(
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: AppbarHrdPage(),
          ),
        ),
      ),
      body: BlocListener<HRDAllSubordinateEmployeeCubit, HRDAllSubordinateEmployeeState>(
        listener: (context, state) {
          if (state is HRDAllSubordinateEmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Ulang',
                  textColor: Colors.white,
                  onPressed: () {
                    _fetchAllSubordinateEmployees();
                  },
                ),
              ),
            );
          }
        },
        child: RefreshIndicator(
          color: AppColors.primaryMain,
          onRefresh: () async {
            _fetchHRDSummary();
            _fetchAllSubordinateEmployees();
            if (isOwner) _fetchEmployeeTrainings();
          },
          child: BlocBuilder<HRDAllSubordinateEmployeeCubit, HRDAllSubordinateEmployeeState>(
            builder: (context, state) {
              if (state is HRDAllSubordinateEmployeeLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView(
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
                    if (_authSharedPref.getEmployeeRole() != "employee")
                      _attendanceRecap(),
                    if (!isOwner) _attendanceService(),
                    if (!isOwner) _employeeService(),
                    if (isOwner) _ownerMenuBar(),
                    if (isOwner) _trainingSection(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _ownerMenuBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 21, left: 16, top: 8),
            child: Text('Layanan Kepegawaian', style: AppTextStyle.headline5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuItem('Pegawai', 'assets/icons/hrd/ic_employee.svg',
                  const HRDEmployeePage()),
              _buildMenuItem(
                  'Kinerja',
                  'assets/icons/hrd/ic_employee_performance.svg',
                  const EmployeePerformancePage()),
              _buildMenuItem('Tasking', 'assets/icons/hrd/ic_tasking.svg',
                  null), // Replace with the correct page
            ],
          ),
        ],
      ),
    );
  }

  Widget _trainingSection() {
    return BlocBuilder<EmployeeTrainingCubit, EmployeeTrainingState>(
      builder: (context, state) {
        if (state is EmployeeTrainingLoading) {
          return ListView.builder(
            itemCount: 2, // Number of shimmer loading cards
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Utils.buildLoadingCardShimmer(),
          );
        } else if (state is EmployeeTrainingLoaded &&
            state.trainingData.trainings.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 8),
                child: Text('Pelatihan Akan Berjalan',
                    style: AppTextStyle.headline5),
              ),
              EmployeeTrainingCardWidget(
                  trainings: state.trainingData.trainings),
            ],
          );
        }else if (state is EmployeeTrainingError){
          return Utils.buildErrorState(
          title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            _fetchEmployeeTrainings();
          },);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMenuItem(String label, String assetPath, Widget? page) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Pegawai':
            Utils.navigateToPage(context, const HRDEmployeePage());
            break;
          case 'Kinerja':
            Utils.navigateToPage(context, const EmployeePerformancePage());
            break;
          case 'Tasking':
            Utils.navigateToPage(context, const SubOrdinateTaskingPage());
            break;
        }
      },
      child: Column(
        children: [
          SvgPicture.asset(assetPath),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyle.caption),
        ],
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

  Widget _attendanceRecap() {
    return GestureDetector(
      onTap: () {
        Utils.navigateToPage(context, const AttendanceRecapPage());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: AppColors.primary100),
          color: AppColors.primaryBackgorund,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/hrd/ic_attendance_recap.svg',
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Text('Rekap Kehadiran Karyawan',
                    style: AppTextStyle.caption
                        .copyWith(color: AppColors.primaryMain)),
              ],
            ),
            const Icon(Icons.arrow_forward, color: AppColors.primaryMain),
          ],
        ),
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
                _buildServiceItem(
                    'Pegawai', 'assets/icons/hrd/ic_employee.svg'),
              _buildServiceItem(
                  'Administrasi', 'assets/icons/hrd/ic_administration.svg'),
              if (_authSharedPref.getEmployeeRole() != "employee")
                _buildServiceItem('Kinerja Pegawai',
                  'assets/icons/hrd/ic_employee_performance.svg'),
              _buildServiceItem('Slip Gaji', 'assets/icons/hrd/ic_salary.svg'),
              _buildServiceItem('Tasking', 'assets/icons/hrd/ic_tasking.svg'),
              _buildServiceItem(
                  'Pelatihan', 'assets/icons/hrd/ic_training.svg'),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToAttendancePage(BuildContext context) async{
    final attendanceData = context.read<HRDSummaryCubit>().state;
    if (attendanceData is HRDSummaryLoaded) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendancePage(data: attendanceData.hrdSummary),
        ),
      );
      if (result == true) {
              _fetchHRDSummary(); // Panggil fungsi untuk refresh data
            }
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
            Utils.navigateToPage(context, PermissionPage());
            break;
          case 'Lembur':
            Utils.navigateToPage(context, const OvertimePage());
            break;
          case 'Slip Gaji':
            Utils.navigateToPage(context, const SalarySlipPage());
            break;
          case 'Pegawai':
            Utils.navigateToPage(context, const HRDEmployeePage());
            break;
          case 'Kinerja Pegawai':
            Utils.navigateToPage(context, const EmployeePerformancePage());
            break;
          case 'Administrasi':
            Utils.navigateToPage(context, const AdministrationPage());
            break;
          case 'Pelatihan':
            Utils.navigateToPage(context, const EmployeeTrainingPage());
            break;
          case 'Tasking':
            switch(_authSharedPref.getEmployeeRole()){
              case 'employee' : 
                Utils.navigateToPage(context, EmployeeTaskingPage());
              case 'manager' : 
                Utils.navigateToPage(context, ManagerTaskingMenu());
            }
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
