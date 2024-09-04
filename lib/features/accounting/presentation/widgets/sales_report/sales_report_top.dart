import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/date_range_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class SalesReportTop extends StatelessWidget {
  final Function onDateTap;

  const SalesReportTop({
    Key? key,
    required this.onDateTap,
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
            leadingWidth: 20,
            title: const Text(
              'Laporan Penjualan',
              style: AppTextStyle.headline5,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      const Text(
                        'Download',
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        'assets/icons/accounting/ic_download.svg',
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          nameDate(context),
        ],
      ),
    );
  }

  Widget nameDate(BuildContext context) {
    return Container(
      decoration: AppThemes.bottomShadow,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 20),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onDateTap(),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackgorund,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<DateRangeCubit, String>(
  builder: (context, state) {
    // Pisahkan rentang tanggal menjadi tanggal awal dan akhir
    final dates = state.split(' - ');
    final startDate = DateTime.parse(dates[0]);
    final endDate = DateTime.parse(dates[1]);

    // Dapatkan tanggal hari ini
    final today = DateTime.now();
    final formattedToday = DateTime(today.year, today.month, today.day);
    final formattedEndDate = DateTime(endDate.year, endDate.month, endDate.day);

    // Hitung selisih hari antara startDate dan endDate
    final difference = formattedEndDate.difference(startDate).inDays + 1; // Adding 1 to count both startDate and endDate

    // Periksa apakah rentang tanggal adalah 7 atau 30 hari terakhir
    final isLast7Days = difference == 8 && formattedEndDate.isAtSameMomentAs(formattedToday);
    final isLast30Days = difference == 31 && formattedEndDate.isAtSameMomentAs(formattedToday);

    // Function to format date to 'd MMMM yyyy' (e.g., 8 Januari 2024)
    String formatDate(DateTime date) {
      return DateFormat('d MMMM yyyy', 'id').format(date);
    }

    // Tampilkan label atau rentang tanggal
    String displayedDate;
    if (isLast7Days) {
      displayedDate = "7 Hari Terakhir";
    } else if (isLast30Days) {
      displayedDate = "30 Hari Terakhir";
    } else {
      // Format start and end dates if they are different
      if (dates[0] == dates[1]) {
        displayedDate = formatDate(startDate); // Single date
      } else {
        displayedDate = "${formatDate(startDate)} - ${formatDate(endDate)}"; // Custom range
      }
    }

    return Text(
      displayedDate,
      style: const TextStyle(
        color: AppColors.primaryMain,
        fontWeight: FontWeight.bold,
      ),
    );
  },
),

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
