


import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/cashier/presentation/pages/cashier_page.dart';
import 'package:akib_pos/features/cashier/presentation/pages/cashier_page.dart';
import 'package:akib_pos/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/hrd_page.dart';
import 'package:akib_pos/features/settings/presentation/pages/settings_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/stockist_page.dart';
import 'package:akib_pos/main.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static List<Widget> pages = [DashboardPage(), CashierPage(), HrdPage(), AccountingPage(), StockistPage(), SettingsPage()];
  static List<String> pageTitles = ["Dashboard", "Kasir", "HRD", "Akunting", "Stockist", "Pengaturan"];

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => pages[0]);
      default:
        return MaterialPageRoute(builder: (_) => pages[0]);
    }
  }
}