import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/pages/asset_management/active_asset.dart';
import 'package:akib_pos/features/accounting/presentation/pages/asset_management/pending_asset.dart';
import 'package:akib_pos/features/accounting/presentation/pages/tax_management_and_tax_services/services_charge_page.dart';
import 'package:akib_pos/features/accounting/presentation/pages/tax_management_and_tax_services/tax_management_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';

class TaxManagementAndTaxServices extends StatelessWidget {
  const TaxManagementAndTaxServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey, // AppColors.backgroundGrey
      appBar: AppBar(
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
          'Management Pajak & Layanan',
          style: AppTextStyle.headline5
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Utils.buildMenuItem(
              context,
              title: 'Manajemen Pajak ',
              onTap: () => _navigateToPage(context,  const TaxManagementPage()),
            ),
            const SizedBox(height: 16),
            Utils.buildMenuItem(
              context,
              title: 'Biaya Layanan',
              onTap: () => _navigateToPage(context,  const ServiceChargePage()),
            ),
          ],
        ),
      ),
    );
  }



  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

}