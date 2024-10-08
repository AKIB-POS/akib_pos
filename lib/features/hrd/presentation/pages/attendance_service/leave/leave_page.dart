
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_quota_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/attendance_service/leave/submit_leave_request_page.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/leave/leave_history_widget.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/leave/leave_quota_widget.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/leave/leave_request_widget.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  @override
  void initState() {
    super.initState();
    _fetchLeaveQuota();
    _fetchLeaveRequests();
    _fetchLeaveHistory(); // Fetch leave history data
  }

  void _fetchLeaveQuota() {
    context.read<LeaveQuotaCubit>().fetchLeaveQuota();
  }

  void _fetchLeaveRequests() {
    context.read<LeaveRequestCubit>().fetchLeaveRequests();
  }

  void _fetchLeaveHistory() {
    context.read<LeaveHistoryCubit>().fetchLeaveHistory();
  }

  Future<void> _refreshLeaveData() async {
    _fetchLeaveQuota();
    _fetchLeaveRequests();
    _fetchLeaveHistory(); // Refresh leave history
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text('Cuti', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.primaryMain),
            onPressed: () {
              
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshLeaveData,
        color: AppColors.primaryMain,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: AppColors.backgroundGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16, left: 16),
                          child: Text('Saldo Cuti',
                              style: AppTextStyle.bigCaptionBold),
                        ),
                        LeaveQuotaWidget(),
                      ],
                    ),
                  ), // Display quota
                  Container(
                    color: AppColors.backgroundGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text('Pengajuan Cuti',
                              style: AppTextStyle.bigCaptionBold),
                        ),
                        const LeaveRequestWidget(),
                        Container(
                          width: double.infinity,
                          height: 20,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                    ),
                    child: Text('Riwayat Cuti',
                        style: AppTextStyle.bigCaptionBold),
                  ),
                  const SizedBox(height: 8,),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: LeaveHistoryWidget(),
                  ), // Display leave history
                ],
              ),
            ),
          ],
        ),
      ),
       floatingActionButton: Utils.buildFloatingActionButton(onPressed: () async {
        // Await the result from the SubmitLeaveRequestPage
        final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubmitLeaveRequestPage(),
      ),
    );

    // Jika result true, refresh data cuti
    if (result == true) {
      _refreshLeaveData();  // Panggil fungsi untuk refresh data
    }
      }),
    );
  }
}
