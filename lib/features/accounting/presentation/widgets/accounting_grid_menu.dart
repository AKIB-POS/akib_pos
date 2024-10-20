import 'package:akib_pos/features/accounting/presentation/pages/asset_management/asset_management.dart';
import 'package:akib_pos/features/accounting/presentation/pages/cash_flow_report.dart';
import 'package:akib_pos/features/accounting/presentation/pages/expenditure_report.dart';
import 'package:akib_pos/features/accounting/presentation/pages/financial_balance_report.dart';
import 'package:akib_pos/features/accounting/presentation/pages/profit_loss_page.dart';
import 'package:akib_pos/features/accounting/presentation/pages/purchasing_report.dart';
import 'package:akib_pos/features/accounting/presentation/pages/sales_report.dart';
import 'package:akib_pos/features/accounting/presentation/pages/tax_management_and_tax_services/tax_management_and_tax_services.dart';
import 'package:akib_pos/features/accounting/presentation/pages/transaction_report.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class AccountingGridMenu extends StatelessWidget {
    final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  // Menu Akunting (Fitur)
  final List<Map<String, String>> menuItems = [
    {"title": "Laporan\nTransaksi", "icon": "assets/icons/accounting/ic_arus_kas.svg", "feature": "transaction-report"},
    {"title": "Laporan\nPenjualan", "icon": "assets/icons/accounting/ic_laporan_penjualan.svg", "feature": "sales-report"},
    {"title": "Laporan\nPembelian", "icon": "assets/icons/accounting/ic_laporan_pembelian.svg", "feature": "purchase-report"},
    {"title": "Laporan\nPengeluaran", "icon": "assets/icons/accounting/ic_laporan_pengeluaran.svg", "feature": "expenditure-report"},
    {"title": "Laba\nRugi", "icon": "assets/icons/accounting/ic_laba_rugi.svg", "feature": "profit-loss"},
    {"title": "Neraca\nKeuangan", "icon": "assets/icons/accounting/ic_neraca_keuangan.svg", "feature": "balance-sheet"},
    {"title": "Arus\nKas", "icon": "assets/icons/accounting/ic_arus_kas.svg", "feature": "cash-flow"}, // Fitur Arus Kas
    {"title": "Manajemen\nNilai Pajak", "icon": "assets/icons/accounting/ic_manajemen_pajak.svg", "feature": "tax-rate-management"},
    {"title": "Manajemen\nAset", "icon": "assets/icons/accounting/ic_manajemen_aset.svg", "feature": "asset-management"},
  ];


   AccountingGridMenu({super.key});

  void onItemTap(int index, BuildContext context) {
  switch (index) {
    case 0:
      // If the first item is clicked
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionReport(),
        ),
      );
      break;
    case 1:
      // If the second item is clicked (you can replace this with your desired action)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SalesReport(), // Replace with your page
        ),
      );
      break;
    case 2:
      // If the second item is clicked (you can replace this with your desired action)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PurchasingReport(), // Replace with your page
        ),
      );
      break;
    case 3:
      // If the second item is clicked (you can replace this with your desired action)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ExpenditureReport(), // Replace with your page
        ),
      );
      break;
    case 4:
      // If the second item is clicked (you can replace this with your desired action)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfitLossPage(), // Replace with your page
        ),
      );
      break;
    case 5:
      // If the second item is clicked (you can replace this with your desired action)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FinancialBalanceReport(), // Replace with your page
        ),
      );
      break;
    case 6:
      // If the second item is clicked (you can replace this with your desired action)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CashFlowReport(), // Replace with your page
        ),
      );
      break;
    case 7:
      // If the second item is clicked (you can replace this with your desired action)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TaxManagementAndTaxServices(), // Replace with your page
        ),
      );
      break;
    case 8:
      // If the second item is clicked (you can replace this with your desired action)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AssetManagement(), // Replace with your page
        ),
      );
      break;
    // Add more cases as needed
    default:
      // Handle any other cases or do nothing
      break;
  }
}

  bool isTabletDevice(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    final aspectRatio = width / height;

    return aspectRatio >= 1.0 && width >= 600;
  }

   @override
  Widget build(BuildContext context) {
    final MobilePermissions? permissions = _authSharedPref.getMobilePermissions();

    // Jika permissions tidak ada, tampilkan pesan error
    if (permissions == null) {
      return Center(child: Text("No permissions available"));
    }

    // Filter menu yang ditampilkan berdasarkan akses di modul accounting
    final List<Map<String, String>> availableMenuItems = menuItems.where((item) {
      // Cek apakah user punya akses ke fitur ini di accounting
      return permissions.accounting.contains(item['feature']);
    }).toList();

    bool isTablet = MediaQuery.of(context).size.width > 600;

    // Render Grid dengan menu yang ada aksesnya
    return AutoHeightGridView(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(),
      itemCount: availableMenuItems.length,
      crossAxisCount: isTablet ? 4 : 2,
      builder: (context, index) {
        return GestureDetector(
          onTap: () {
            onItemTap(index, context);
          },
          child: AccountingMenuItem(
            title: availableMenuItems[index]["title"]!,
            iconPath: availableMenuItems[index]["icon"]!,
          ),
        );
      },
    );
  }
}

class AccountingMenuItem extends StatelessWidget {
  final String title;
  final String iconPath;

  AccountingMenuItem({required this.title, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(16.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                "assets/images/bg_card_accounting.svg", // Background image (optional)
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      SvgPicture.asset(
                        iconPath,
                        height: 40,
                        width: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}