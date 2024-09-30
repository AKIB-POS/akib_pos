import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_history.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_history_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionHistoryWidget extends StatelessWidget {
  const PermissionHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionHistoryCubit, PermissionHistoryState>(
      builder: (context, state) {
        if (state is PermissionHistoryLoading) {
          return _buildLoadingShimmer(); // Display shimmer when loading
        } else if (state is PermissionHistoryError) {
          return Center(child: Text(state.message)); // Display error message
        } else if (state is PermissionHistoryLoaded) {
          if (state.permissionHistory.data.isEmpty) {
            return Utils.buildEmptyState(
              "Belum ada Riwayat",
              "Riwayat akan tampil setelah\nizin anda telah selesai"
            );
          } else {
            return _buildPermissionHistoryList(state.permissionHistory.data);
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPermissionHistoryList(List<PermissionHistoryData> permissionHistory) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: permissionHistory.length,
      itemBuilder: (context, index) {
        final item = permissionHistory[index];
        return _buildPermissionHistoryItem(item);
      },
    );
  }

  Widget _buildPermissionHistoryItem(PermissionHistoryData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textGrey300), // Border with grey color
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.permissionType, style: AppTextStyle.bigCaptionBold),
                  const SizedBox(height: 4),
                  Text(
                    '${item.startDate} - ${item.time}',
                    style: AppTextStyle.caption.copyWith(color: AppColors.textGrey500),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item.status == "Disetujui"
                    ? AppColors.successMain.withOpacity(0.1)
                    : AppColors.errorMain.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.status,
                style: TextStyle(
                  color: item.status == "Disetujui" ? AppColors.successMain : AppColors.errorMain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
