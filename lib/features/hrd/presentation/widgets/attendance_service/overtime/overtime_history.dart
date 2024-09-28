import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_history.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/overtime_history_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OvertimeHistoryWidget extends StatelessWidget {
  const OvertimeHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OvertimeHistoryCubit, OvertimeHistoryState>(
      builder: (context, state) {
        if (state is OvertimeHistoryLoading) {
          return _buildLoadingShimmer(); // Display shimmer when loading
        } else if (state is OvertimeHistoryError) {
          return Utils.buildErrorState(
          title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            context.read<OvertimeHistoryCubit>().fetchOvertimeHistory();
          },);// Display error message
        } else if (state is OvertimeHistoryLoaded) {
          if (state.overtimeHistory.data.isEmpty) {
            return Utils.buildEmptyState("Belum ada Riwayat",
                "Riwayat akan tampil setelah\nlembur anda telah selesai");
          } else {
            return _buildOvertimeHistoryList(state.overtimeHistory.data);
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

  Widget _buildOvertimeHistoryList(List<OvertimeHistoryData> overtimeHistory) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: overtimeHistory.length,
      itemBuilder: (context, index) {
        final item = overtimeHistory[index];
        return _buildOvertimeHistoryItem(item);
      },
    );
  }

  Widget _buildOvertimeHistoryItem(OvertimeHistoryData item) {
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
          crossAxisAlignment: CrossAxisAlignment.center, // Aligns items at the top
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.overtimeDescription, style: AppTextStyle.bigCaptionBold),
                  const SizedBox(height: 4),
                  Text(
                    '${item.startDatetime} - ${item.endDatetime}',
                    style: AppTextStyle.caption.copyWith(color: AppColors.textGrey500),
                    maxLines: 2, // Allow text to wrap to the next line if needed
                    overflow: TextOverflow.visible, // Make sure the text wraps to the next line
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8), // Add spacing between text and status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item.status == "Selesai"
                    ? AppColors.successMain.withOpacity(0.1)
                    : AppColors.errorMain.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.status,
                style: TextStyle(
                  color: item.status == "Selesai" ? AppColors.successMain : AppColors.errorMain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
