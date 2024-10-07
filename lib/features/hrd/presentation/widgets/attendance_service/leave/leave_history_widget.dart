import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_history.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_history_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LeaveHistoryWidget extends StatelessWidget {
  const LeaveHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveHistoryCubit, LeaveHistoryState>(
      builder: (context, state) {
        if (state is LeaveHistoryLoading) {
          return _buildLoadingShimmer(); // Display shimmer when loading
        } else if (state is LeaveHistoryError) {
          return Utils.buildErrorState(
          title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            context.read<LeaveHistoryCubit>().fetchLeaveHistory();
          },
        );
        } else if (state is LeaveHistoryLoaded) {
          if (state.leaveHistory.data.isEmpty) {
            return Utils.buildEmptyState("Belum ada Riwayat",
            "Riwayat akan tampil setelah\nizin anda telah selesai");
          } else {
            return  _buildLeaveHistoryList(state.leaveHistory.data);
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
 Widget _buildEmptyState() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/accounting/empty_report.svg',
            height: 150,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada Pengajuan',
            style: AppTextStyle.bigCaptionBold,
          ),
          const SizedBox(height: 8),
          const Text(
            'Status Pengajuan akan tampil setelah anda\nmengisi form pengajuan cuti',
            textAlign: TextAlign.center,
            style: AppTextStyle.caption,
          ),
        ],
      ),
    );
  }
  Widget _buildLeaveHistoryList(List<LeaveHistoryData> leaveHistory) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaveHistory.length,
      itemBuilder: (context, index) {
        final item = leaveHistory[index];
        return _buildLeaveHistoryItem(item);
      },
    );
  }

  Widget _buildLeaveHistoryItem(LeaveHistoryData item) {
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
          Text(item.leaveType, style: AppTextStyle.bigCaptionBold),
          const SizedBox(height: 4),
          Text(
            '${item.startDate} - ${item.endDate}',
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
