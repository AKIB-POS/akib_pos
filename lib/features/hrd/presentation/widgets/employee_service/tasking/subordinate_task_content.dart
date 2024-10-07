import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_tasking_model.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/tasking/detail_subordinate_task_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SubordinateTaskContent extends StatelessWidget {
  final SubordinateTaskModel task;
  final String status; // 'FINISHED' atau 'UNFINISHED'

  const SubordinateTaskContent({
    Key? key,
    required this.task,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'FINISHED'
        ? AppColors.successMain
        : AppColors.warningMain;

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(task.taskSubmissionDate),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Pegawai dan Tugas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(  // Tambahkan Expanded agar teks dapat wrap
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(task.taskingEmployeeName, style: AppTextStyle.headline5),
                          const SizedBox(height: 4),
                          Text(task.taskingName,
                              style: AppTextStyle.caption,
                              maxLines: 2, // Batasan 2 baris
                              overflow: TextOverflow.ellipsis // Tambahkan ellipsis jika terlalu panjang
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10), // Spasi antara teks dan tombol
                    OutlinedButton(
                      onPressed: () {
                        Utils.navigateToPage(context, DetailSubordinateTaskPage(taskingId: task.taskingId));
                      },
                      style: AppThemes.outlineButtonPrimaryStyle,
                      child: const Text('Detail', style: TextStyle(color: AppColors.primaryMain)),
                    ),
                  ],
                ),
                // Waktu Penyelesaian Tugas
                _buildTaskEndDate(task.taskEndDatetime),
                const SizedBox(height: 8),
                // Status Task
                _buildTaskStatus(task.taskStatus, statusColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header dengan Tanggal Submission
  Widget _buildHeader(String submissionDate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Text(
        'Tanggal: $submissionDate',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // Tampilkan Tenggat Waktu
  Widget _buildTaskEndDate(String endDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tenggat Waktu:', style: AppTextStyle.caption.copyWith(color: AppColors.textGrey600)),
        Text(endDate, style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Status Penyelesaian Tugas
  Widget _buildTaskStatus(String taskStatus, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: statusColor.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            taskStatus,
            style: AppTextStyle.caption.copyWith(color: statusColor),
          ),
          SvgPicture.asset(
            status == 'FINISHED' ? 'assets/icons/success.svg' : 'assets/icons/pending.svg',
            height: 24,
            width: 24,
          ),
        ],
      ),
    );
  }
}
