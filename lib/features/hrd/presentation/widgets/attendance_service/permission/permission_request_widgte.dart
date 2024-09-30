import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_request.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_request_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PermissionRequestWidget extends StatelessWidget {
  const PermissionRequestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionRequestCubit, PermissionRequestState>(
      builder: (context, state) {
        if (state is PermissionRequestLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Utils.buildLoadingCardShimmer()],
          );
        } else if (state is PermissionRequestLoaded) {
          if (state.permissionRequest.data.isEmpty) {
            return buildEmptyUI();
          } else {
            return _buildRequestList(state.permissionRequest.data);
          }
        } else if (state is PermissionRequestError) {
          return buildEmptyUI();
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildEmptyUI() {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Utils.buildEmptyState("Belum ada Pengajuan",
            "Status Pengajuan akan tampil setelah anda\nmengisi form pengajuan izin"));
  }

  Widget _buildRequestList(List<PermissionRequest> requests) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 16, left: 16),
      child: Column(
        children:
            requests.map((request) => _buildRequestItem(request)).toList(),
      ),
    );
  }

  Widget _buildRequestItem(PermissionRequest request) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(request.requestDate),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  request.permissionType,
                  style: AppTextStyle.headline5,
                ),
                const SizedBox(height: 8),
                Text(
                  "${request.startDate} - ${request.time}",
                  style: AppTextStyle.caption
                      .copyWith(color: AppColors.textGrey800),
                ),
                const SizedBox(height: 12),
                _buildApprovalStatusRow(
                    'Status Persetujuan', request.approverName),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the date header
  Widget _buildDateHeader(String date) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Text(
        date,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget for displaying approval status
  Widget _buildApprovalStatusRow(String title, String approverName) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.backgroundGrey,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.caption,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "$approverName : ",
                style: AppTextStyle.caption,
              ),
              const SizedBox(width: 2),
              SvgPicture.asset(
                'assets/icons/hrd/ic_clock_pending.svg',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
