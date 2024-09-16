import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_summary.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_summary_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:intl/intl.dart';

class AttendancePage extends StatelessWidget {
  final AttendanceSummaryData data;

  AttendancePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Absensi', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAttendanceBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceBody() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'ID').format(now);

    // Parse expectedClockInTime to a DateTime object
    DateTime? expectedClockInDateTime;
    if (data.expectedClockInTime != null) {
      expectedClockInDateTime = DateFormat('HH:mm').parse(data.expectedClockInTime!);
    }

    // Determine button colors
    bool isClockInEnabled = data.clockInTime == null && 
                            (expectedClockInDateTime != null && now.isAfter(expectedClockInDateTime));
    bool isClockOutEnabled = data.clockInTime != null && data.clockOutTime == null;

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.textGrey300,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Column(
              children: [
                Text(
                  formattedDate,
                  style: AppTextStyle.body2,
                ),
                const SizedBox(height: 8),
                Text(
                  "${data.expectedClockInTime} - ${data.expectedClockOutTime}",
                  style: AppTextStyle.headline5.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Absen Masuk', style: AppTextStyle.caption),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: data.clockInTime != null
                          ? AppColors.successMain.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data.clockInTime ?? '-- : --',
                      style: AppTextStyle.bigCaptionBold.copyWith(
                        color: data.clockInTime != null
                            ? AppColors.successMain
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 2,
                height: 40,
                color: AppColors.textGrey300,
              ),
              Column(
                children: [
                  const Text('Absen Pulang', style: AppTextStyle.caption),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: data.clockOutTime != null
                          ? AppColors.errorMain.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data.clockOutTime ?? '-- : --',
                      style: AppTextStyle.bigCaptionBold.copyWith(
                        color: data.clockOutTime != null
                            ? AppColors.errorMain
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 10),
              _buildActionButton(
                'Masuk',
                isClockInEnabled ? AppColors.successMain : Colors.grey,
              ),
              const SizedBox(width: 10),
              _buildActionButton(
                'Keluar',
                isClockOutEnabled ? AppColors.errorMain : Colors.grey,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return Expanded(
      child: SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: color == Colors.grey
              ? null // Disable the button if color is grey
              : () {
                  // Handle button press
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
