import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_quota_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class LeaveQuotaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveQuotaCubit, LeaveQuotaState>(
      builder: (context, state) {
        if (state is LeaveQuotaLoading) {
          return _buildLoadingShimmer();
        } else if (state is LeaveQuotaError) {
          return Center(child: Text(state.message));
        } else if (state is LeaveQuotaLoaded) {
          final data = state.leaveQuota.data;
          return _buildLeaveQuotaContent(data.totalQuota, data.usedQuota);
        } else {
          return Container();
        }
      },
    );
  }

  // Build the progress bar UI
  Widget _buildLeaveQuotaContent(int totalQuota, int usedQuota) {
    double progress = usedQuota / totalQuota;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
        child: Stack(
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Background color for remaining leave
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primaryMain, // Progress bar color
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Center(
              child: Text(
                '$usedQuota Dari $totalQuota Hari',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the loading shimmer UI
  Widget _buildLoadingShimmer() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            // Shimmer for the progress bar
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Background color for shimmer
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // Shimmer for the text inside the progress bar
            
          ],
        ),
      ),
    ),
  );
}

}
