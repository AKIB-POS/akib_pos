import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_quota_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/leave/leave_quota_widget.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/leave/leave_request_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // Ensure to add shimmer package in pubspec.yaml
class LeavePage extends StatefulWidget {
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  @override
  void initState() {
    super.initState();
    _fetchLeaveQuota();
    _fetchLeaveRequests(); 
  }

  void _fetchLeaveQuota() {
    context.read<LeaveQuotaCubit>().fetchLeaveQuota();
  }

  void _fetchLeaveRequests() {
    context.read<LeaveRequestCubit>().fetchLeaveRequests();
  }

  Future<void> _refreshLeaveData() async {
    _fetchLeaveQuota();
    _fetchLeaveRequests(); // Refresh leave requests
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cuti', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.primaryMain),
            onPressed: () {
              // Handle info button press
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
              padding: EdgeInsets.only(bottom: 21),
              color: AppColors.backgroundGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeaveQuotaWidget(), // Display quota
                  Padding(
                padding: const EdgeInsets.only(left: 16),
                child: const Text('Pengajuan Cuti', style: AppTextStyle.bigCaptionBold),
              ),
                  LeaveRequestWidget(), // Display requests
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
