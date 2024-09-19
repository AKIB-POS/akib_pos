import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/attenddance_recap.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/attendance_recap_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceRecapContentWidget extends StatelessWidget {
  const AttendanceRecapContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceRecapCubit, AttendanceRecapState>(
      builder: (context, state) {
        if (state is AttendanceRecapLoading) {
          return _buildShimmerLoading();
        } else if (state is AttendanceRecapError) {
          return Center(child: Text(state.message));
        } else if (state is AttendanceRecapLoaded) {
          return _buildAttendanceRecapContent(state.attendanceRecap);
        } else {
          return Container(); // Placeholder for the initial state
        }
      },
    );
  }

  // Shimmer loading UI
  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerSection(title: 'Durasi Jam Kerja'),
          const SizedBox(height: 16),
          _buildShimmerSection(title: 'Saldo Cuti'),
          const SizedBox(height: 16),
          _buildShimmerSection(title: 'Izin'),
          const SizedBox(height: 16),
          _buildShimmerSection(title: 'Alpa'),
          const SizedBox(height: 16),
          _buildShimmerSection(title: 'Lembur'),
        ],
      ),
    );
  }

  Widget _buildShimmerSection({required String title}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.headline5.copyWith(fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 12),
            Container(
              height: 20,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRecapContent(AttendanceRecap attendanceRecap) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Work Duration Section
          _buildSection(
            title: 'Durasi Jam Kerja',
            content: attendanceRecap.workDuration,
          ),
          const SizedBox(height: 16),

          // Leave Balance Section
          _buildSection(
            title: 'Saldo Cuti',
            content: attendanceRecap.leaveBalance.totalLeave,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.textGrey100,
              ),
              child: Column(
                children: attendanceRecap.leaveBalance.details.map((detail) {
                  return _buildDetailRow(detail.leaveType, detail.days);
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Permissions Section
          _buildSection(
            title: 'Izin',
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.textGrey100,
              ),
              child: Column(
                children: attendanceRecap.permissions.map((permission) {
                  return _buildDetailRow(
                    permission.permissionType,
                    permission.duration,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Alpha Section
          _buildSection(
            title: 'Alpa',
            content: attendanceRecap.alpha,
          ),
          const SizedBox(height: 16),

          // Overtime Duration Section
          _buildSection(
            title: 'Lembur',
            content: attendanceRecap.overtimeDuration,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, String? content, Widget? child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyle.headline5.copyWith(fontWeight: FontWeight.normal),
              ),
              if (content != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    content,
                    style: AppTextStyle.bigCaptionBold.copyWith(
                      color: AppColors.textGrey800,
                    ),
                  ),
                ),
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: 12),
            child,
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.caption.copyWith(color: AppColors.textGrey800),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.textGrey300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
