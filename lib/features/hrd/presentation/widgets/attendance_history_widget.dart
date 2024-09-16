import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_history_item.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceHistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceHistoryCubit, AttendanceHistoryState>(
      builder: (context, state) {
        if (state is AttendanceHistoryLoading) {
          return _buildLoadingShimmer();
        } else if (state is AttendanceHistoryError) {
          return Center(child: Text(state.message));
        } else if (state is AttendanceHistoryLoaded) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Riwayat Absensi",style: AppTextStyle.headline5,),
                SizedBox(height: 10,),
                _buildAttendanceHistoryList(state.attendanceHistory.data),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 100,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttendanceHistoryList(List<AttendanceHistoryItem> historyList) {
    return ListView.builder(
      itemCount: historyList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final history = historyList[index];
        return _buildHistoryCard(history);
      },
    );
  }

  Widget _buildHistoryCard(AttendanceHistoryItem history) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.textGrey300,
          width: 1
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.primaryMain,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              history.date,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Absen Masuk', style: AppTextStyle.caption),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.successMain.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                    child: Row(
                      children: [
                        Text(
                          history.clockInTime,
                          style: AppTextStyle.bigCaptionBold
                              .copyWith(color: AppColors.successMain),
                        ),
                        Text(
                          " - ${history.clockInStatus}",
                          style: AppTextStyle.bigCaptionBold
                              .copyWith(color: AppColors.successMain),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Absen Pulang', style: AppTextStyle.caption),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.errorMain.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                    child: Row(
                      children: [
                        Text(
                          history.clockOutTime,
                          style: AppTextStyle.bigCaptionBold
                              .copyWith(color: AppColors.errorMain),
                        ),
                        Text(
                          " - ${history.clockOutStatus}",
                          style: AppTextStyle.bigCaptionBold
                              .copyWith(color: AppColors.errorMain),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
