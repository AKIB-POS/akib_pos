import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

class SummaryAttendance extends StatelessWidget {
  final String? role;
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  SummaryAttendance({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Absen Masuk', style: AppTextStyle.caption),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.successMain.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '07 : 48',
                        style: AppTextStyle.bigCaptionBold
                            .copyWith(color: AppColors.successMain),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.errorMain.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '-- : --',
                        style: TextStyle(
                          color: AppColors.errorMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Middle section with Saldo Cuti, Saldo Izin, Pengajuan
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // SVG Background
                  Positioned.fill(
                    child: SvgPicture.asset(
                      'assets/images/hrd/bg_card_summary.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoColumn('12', 'Saldo Cuti'),
                            _buildInfoColumn('12', 'Saldo Izin'),
                            // Conditionally render Pengajuan column
                            if (role != "employee")
                              _buildInfoColumn('4', 'Pengajuan'),
                          ],
                        ),
                        // Conditionally render Cek Pengajuan Karyawan section
                        if (role != "employee")
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/hrd/ic_employee_submission.svg',
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Cek Pengajuan Karyawan',
                                            style: AppTextStyle.caption.copyWith(
                                                color: AppColors.primaryMain)),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward,
                                        color: AppColors.primaryMain),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.bigCaptionBold.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
