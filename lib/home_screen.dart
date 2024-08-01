import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/my_app_sidebar.dart';
import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_mode_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/pages/cashier_page.dart';
import 'package:akib_pos/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:akib_pos/features/settings/presentation/pages/settings_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/stockist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sidebarx/sidebarx.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CashierModeCubit>(
      create: (context) => CashierModeCubit(),
      child: _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  final SidebarXController _controller = SidebarXController(selectedIndex: 0, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
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
      drawer: MyAppSidebar(controller: _controller, setKasirMode: (mode) => context.read<CashierModeCubit>().setMode(mode), isSmallScreen: isSmallScreen),
      body: Row(
        children: [
          if (!isSmallScreen) MyAppSidebar(controller: _controller, setKasirMode: (mode) => context.read<CashierModeCubit>().setMode(mode), isSmallScreen: isSmallScreen),
          Expanded(
            child: Center(
              child: BlocBuilder<CashierModeCubit, String>(
                builder: (context, kasirMode) {
                  return _ScreensExample(controller: _controller, kasirMode: kasirMode);
                },
              ),
            ),
          ),
        ],
      ),
    );
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

