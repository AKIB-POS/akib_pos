import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/administration/company_rules_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/administration/employee_sop_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/administration/employee_warning_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey, // AppColors.backgroundGrey
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: const Text(
          'Administrasi',
          style: AppTextStyle.headline5,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Utils.buildMenuItem(
              context,
              title: 'Peraturan Perusahaan',
              onTap: () {
                Utils.navigateToPage(context, CompanyRulesPage());
              }, 
            ),
            const SizedBox(height: 16),
            Utils.buildMenuItem(
              context,
              title: 'SOP Pelayanan',
              onTap: () {
                Utils.navigateToPage(context, const EmployeeSOPPage());
              },
            ),
            const SizedBox(height: 16),
            Utils.buildMenuItem(
              context,
              title: 'Surat Peringatan',
              onTap: () {
                Utils.navigateToPage(context, const EmployeeWarningPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
