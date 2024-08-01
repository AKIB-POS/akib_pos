import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/cashier/presentation/pages/cashier_page.dart';
import 'package:akib_pos/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:akib_pos/features/settings/presentation/pages/settings_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/stockist_page.dart';
import 'package:akib_pos/home_screen.dart';
import 'package:akib_pos/main.dart';
import 'package:akib_pos/splash_screen.dart';
import 'package:flutter/material.dart';



class AppRoute {
  static const splash = '/';
  static const home = '/home';
  static const dashboard = '/dashboard';
  static const kasir = '/kasir';
  static const accounting = '/accounting';
  static const stockist = '/stockist';
  static const setting = '/settings';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (context) =>  const SplashScreen(),
        );
      case home:
        return MaterialPageRoute(
          builder: (context) =>   const HomeScreen(),
        );
      case dashboard:
        return MaterialPageRoute(
          builder: (context) =>  DashboardPage(),
        );
      case kasir:
        final args = settings.arguments as String?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (context) => CashierPage(mode: args),
          );
        }
        return _notFoundPage;
      case accounting:
        return MaterialPageRoute(
          builder: (context) =>  AccountingPage(),
        );
      case stockist:
        return MaterialPageRoute(
          builder: (context) =>  StockistPage(),
        );
      case setting:
        return MaterialPageRoute(
          builder: (context) =>  SettingsPage(),
        );
      default:
        return _notFoundPage;
    }
  }

  static MaterialPageRoute get _notFoundPage => MaterialPageRoute(
        builder: (context) =>  const Scaffold(
          body: Center(
            child: Text('Page Not Found'),
          ),
        ),
      );
}