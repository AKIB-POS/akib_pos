import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave_quota_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/leave/leave_quota_widget.dart';
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
  }

  void _fetchLeaveQuota() {
    context.read<LeaveQuotaCubit>().fetchLeaveQuota();
  }

  Future<void> _refreshLeaveQuota() async {
    // You can call the same function to fetch data
    _fetchLeaveQuota();
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
        onRefresh: _refreshLeaveQuota, // Callback for pull-to-refresh
        color: AppColors.primaryMain,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 21),
              color: AppColors.backgroundGrey,
              child: Column(
                children: [
                  LeaveQuotaWidget(),
                ],
              ),
            ), // Use the new widget here
          ],
        ),
      ),
    );
  }
}
