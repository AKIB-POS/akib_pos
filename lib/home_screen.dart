import 'package:akib_pos/common/my_app_sidebar.dart';
import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/cashier/presentation/pages/cashier_page.dart';
import 'package:akib_pos/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:akib_pos/features/settings/presentation/pages/settings_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/stockist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SidebarXController _controller = SidebarXController(selectedIndex: 0, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  String _kasirMode = 'portrait';

  void _setKasirMode(String mode) {
    setState(() {
      _kasirMode = mode;
      if (mode == 'landscape') {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      }
    });
  }

  @override
  void dispose() {
    // Reset orientation when the widget is disposed
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Builder(
      builder: (context) {
        return Scaffold(
          key: _key,
          appBar: isSmallScreen
              ? AppBar(
                  backgroundColor: canvasColor,
                  title: Text(_getTitleByIndex(_controller.selectedIndex)),
                  leading: IconButton(
                    onPressed: () {
                      _key.currentState?.openDrawer();
                    },
                    icon: const Icon(Icons.menu),
                  ),
                )
              : null,
          drawer: MyAppSidebar(controller: _controller, setKasirMode: _setKasirMode, isSmallScreen: isSmallScreen),
          body: Row(
            children: [
              if (!isSmallScreen) MyAppSidebar(controller: _controller, setKasirMode: _setKasirMode, isSmallScreen: isSmallScreen),
              Expanded(
                child: Center(
                  child: _ScreensExample(controller: _controller, kasirMode: _kasirMode),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScreensExample extends StatelessWidget {
  final SidebarXController controller;
  final String kasirMode;

  const _ScreensExample({
    Key? key,
    required this.controller,
    required this.kasirMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (controller.selectedIndex) {
      case 0:
        return  DashboardPage();
      case 1:
        return CashierPage(mode: kasirMode);
      case 2:
        return  AccountingPage();
      case 3:
        return  StockistPage();
      case 4:
        return  SettingsPage();
      default:
        return  Center(child: Text('Page not found'));
    }
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Dashboard';
    case 1:
      return 'Kasir';
    case 2:
      return 'Accounting';
    case 3:
      return 'Stockist';
    case 4:
      return 'Settings';
    default:
      return 'Not found page';
  }
}