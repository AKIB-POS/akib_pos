import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/data/models/purchasing_report/purchasing_item_model.dart';
import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/accounting/presentation/pages/asset_management/active_asset.dart';
import 'package:akib_pos/features/accounting/presentation/pages/asset_management/asset_depreciation.dart';
import 'package:akib_pos/features/accounting/presentation/pages/asset_management/pending_asset.dart';
import 'package:akib_pos/features/accounting/presentation/pages/asset_management/sold_asset.dart';
import 'package:akib_pos/util/utils.dart';
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
        titleSpacing: 0,
        title: const Text(
          'Management Aset',
          style: AppTextStyle.headline5
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Utils.buildMenuItem(
              context,
              title: 'Aset Tertunda',
              onTap: () => _navigateToPage(context,  const PendingAssetPage()),
            ),
            const SizedBox(height: 16),
            Utils.buildMenuItem(
              context,
              title: 'Aset Aktif',
              onTap: () => _navigateToPage(context,  const ActiveAssetPage()),
            ),
            const SizedBox(height: 16),
            Utils.buildMenuItem(
              context,
              title: 'Dijual/Dilepas',
              onTap: () => _navigateToPage(context,  const SoldAssetPage()),
            ),
            const SizedBox(height: 16),
            Utils.buildMenuItem(
              context,
              title: 'Penyusutan',
              onTap: () => _navigateToPage(context, const AssetDepreciationPage()),
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