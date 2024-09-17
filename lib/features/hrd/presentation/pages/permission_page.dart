import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_quota_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/permission/permission_history_widget.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/permission/permission_quota_widget.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/permission/permission_request_widgte.dart';
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
    _fetchPermissionRequests();
    _fetchPermissionHistory();
  }

  void _fetchPermissionQuota() {
    context.read<PermissionQuotaCubit>().fetchPermissionQuota();
  }

  void _fetchPermissionRequests() {
    context.read<PermissionRequestCubit>().fetchPermissionRequests();
  }

  void _fetchPermissionHistory() {
    context.read<PermissionHistoryCubit>().fetchPermissionHistory();
  }

  Future<void> _refreshPermissionData() async {
    _fetchPermissionQuota(); 
    _fetchPermissionRequests();
    _fetchPermissionHistory(); // Refresh permission history
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
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
                          child: Text('Saldo Izin', style: AppTextStyle.bigCaptionBold),
                        ),
                        PermissionQuotaWidget(), // Display permission quota
                      ],
                    ),
                  ),
                  Container(
                    color: AppColors.backgroundGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text('Pengajuan Izin', style: AppTextStyle.bigCaptionBold),
                        ),
                        const PermissionRequestWidget(), // Display permission requests
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
                  const Padding(
                    padding: EdgeInsets.only(left: 16,),
                    child: Text('Riwayat Izin', style: AppTextStyle.bigCaptionBold),
                  ),
                  const SizedBox(height: 8),
                  const PermissionHistoryWidget(), // Display permission history
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
