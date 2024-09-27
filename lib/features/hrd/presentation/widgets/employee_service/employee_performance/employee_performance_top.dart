import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmployeePerformanceTop extends StatelessWidget {
  final String selectedMonth;
  final int selectedYear;
  final Function onMonthYearTap;

  const EmployeePerformanceTop({
    Key? key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthYearTap,
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
              onPressed: () => Navigator.of(context).pop(),
            ),
            titleSpacing: 0,
            title: const Text(
              'Kinerja Pegawai',
              style: AppTextStyle.headline5,
            ),
          ),
          monthYearSelector(context),
        ],
      ),
    );
  }

  Widget monthYearSelector(BuildContext context) {
    return Container(
      decoration: AppThemes.bottomShadow,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 20),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onMonthYearTap(),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackgorund,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$selectedMonth $selectedYear',
                        style: const TextStyle(
                          color: AppColors.primaryMain,
                          fontWeight: FontWeight.bold,
                        ),
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
