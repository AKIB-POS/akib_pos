import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/purchasing_report/purchasing_item_model.dart';
import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/accounting/presentation/pages/asset_management/pending_asset.dart';
import 'package:flutter/material.dart';

class AssetManagement extends StatelessWidget {
  const AssetManagement({super.key});

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
        leadingWidth: 20,
        title: const Text(
          'Management Aset',
          style: AppTextStyle.headline5
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMenuItem(
              context,
              title: 'Aset Tertunda',
              onTap: () => _navigateToPage(context,  PendingAssetPage()),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              context,
              title: 'Aset Aktif',
              onTap: () => _navigateToPage(context,  AccountingPage()),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              context,
              title: 'Dijual/Dilepas',
              onTap: () => _navigateToPage(context,  AccountingPage()),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              context,
              title: 'Penyusutan',
              onTap: () => _navigateToPage(context, AccountingPage()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyle.bigCaptionBold
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
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