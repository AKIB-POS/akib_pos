import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/date_range_pruchase_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/attendance_recap_interaction_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/date_range_attendance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class AttendanceRecapTop extends StatelessWidget {
  final Function onDateTap;
  final Function onEmployeeTap;

  const AttendanceRecapTop({
    Key? key,
    required this.onDateTap,
    required this.onEmployeeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AppBar(
            forceMaterialTransparency: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            titleSpacing: 0,
            title: const Text(
              'Rekap Kehadiran',
              style: AppTextStyle.headline5,
            ),
          ),
          nameDateEmployee(context),
        ],
      ),
    );
  }

  Widget nameDateEmployee(BuildContext context) {
    return Container(
      decoration: AppThemes.bottomShadow,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 20),
        child: Row(
          children: [
            // Employee selection
            Expanded(
              child: GestureDetector(
                onTap: () => onEmployeeTap(),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackgorund,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded( // Use Expanded to limit the space for the text
                        child: BlocBuilder<AttendanceRecapInteractionCubit, AttendanceRecapInteractionState>(
                          builder: (context, state) {
                            return Text(
                              state.employeeName,
                              style: const TextStyle(
                                color: AppColors.primaryMain,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis, // Handle overflow
                              maxLines: 1, // Make sure it stays on one line
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8), // Add spacing between text and icon
                      SvgPicture.asset(
                        'assets/icons/accounting/ic_user_square.svg',
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Date selection
            Expanded(
              child: GestureDetector(
                onTap: () => onDateTap(),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackgorund,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded( // Use Expanded to limit the space for the text
                        child: BlocBuilder<DateRangeAttendanceCubit, String>(
                          builder: (context, state) {
                            final dates = state.split(' - ');
                            final startDate = DateTime.parse(dates[0]);
                            final endDate = DateTime.parse(dates[1]);

                            // Calculate if the date range is "7 Hari Terakhir" or "30 Hari Terakhir"
                            final today = DateTime.now();
                            final formattedToday = DateTime(today.year, today.month, today.day);
                            final formattedEndDate = DateTime(endDate.year, endDate.month, endDate.day);

                            final difference = formattedEndDate.difference(startDate).inDays + 1;

                            final isLast7Days = difference == 8 && formattedEndDate.isAtSameMomentAs(formattedToday);
                            final isLast30Days = difference == 31 && formattedEndDate.isAtSameMomentAs(formattedToday);

                            String formatDate(DateTime date) {
                              return DateFormat('d MMMM yyyy', 'id').format(date);
                            }

                            String displayedDate;
                            if (isLast7Days) {
                              displayedDate = "7 Hari Terakhir";
                            } else if (isLast30Days) {
                              displayedDate = "30 Hari Terakhir";
                            } else {
                              if (dates[0] == dates[1]) {
                                displayedDate = formatDate(startDate);
                              } else {
                                displayedDate = "${formatDate(startDate)} - ${formatDate(endDate)}";
                              }
                            }

                            return Text(
                              displayedDate,
                              style: const TextStyle(
                                color: AppColors.primaryMain,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis, // Handle overflow
                              maxLines: 1, // Make sure it stays on one line
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8), // Add spacing between text and icon
                      SvgPicture.asset(
                        'assets/icons/accounting/ic_calendar.svg',
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
