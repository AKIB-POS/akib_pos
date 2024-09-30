import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SalarySlipTop extends StatelessWidget {
  final int selectedYear;
  final Function onYearTap;

  const SalarySlipTop({
    Key? key,
    required this.selectedYear,
    required this.onYearTap,
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
              'Slip Gaji',
              style: AppTextStyle.headline5,
            ),
          ),
          yearSelector(context),
        ],
      ),
    );
  }

  Widget yearSelector(BuildContext context) {
    return Container(
      decoration: AppThemes.bottomShadow,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 20),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onYearTap(),
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
                        '$selectedYear',
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
