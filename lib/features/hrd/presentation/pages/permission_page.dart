import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_quota_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/permission/permission_quota_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionPage extends StatefulWidget {
  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  @override
  void initState() {
    super.initState();
    _fetchPermissionQuota();
  }

  void _fetchPermissionQuota() {
    context.read<PermissionQuotaCubit>().fetchPermissionQuota();
  }

  Future<void> _refreshPermissionData() async {
    _fetchPermissionQuota(); // Refresh permission quota
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Izin', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.primaryMain),
            onPressed: () {
              // Handle info button press
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPermissionData,
        color: AppColors.primaryMain,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 21),
              color: AppColors.backgroundGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                          padding: EdgeInsets.only(top: 16, left: 16),
                          child: Text('Saldo Izin',
                              style: AppTextStyle.bigCaptionBold),
                        ),
                  PermissionQuotaWidget(), // Display permission quota
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
