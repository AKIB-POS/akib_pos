import 'package:akib_pos/common/custom_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class MyAppSidebar extends StatelessWidget {
  final SidebarXController controller;
  final Function(String) setKasirMode;
  final bool isSmallScreen;

  const MyAppSidebar({
    Key? key,
    required this.controller,
    required this.setKasirMode,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: accentCanvasColor,
        textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.black),
        hoverTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: primaryColor,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: const BoxDecoration(
          color: canvasColor,
        ),
        textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
        itemTextPadding: const EdgeInsets.only(left: 20),
        selectedItemTextPadding: const EdgeInsets.only(left: 20),
        iconTheme: IconThemeData(
          color: primaryColor,
          size: 24,
        ),
        selectedIconTheme: const IconThemeData(
          color: primaryColor,
          size: 24,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return Column(
          children: [
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assets/images/avatar.png'),
              ),
            ),
            if (extended || isSmallScreen)
              Column(
                children: const [
                  Text(
                    'Employee Name',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Cashier',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
          ],
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.dashboard,
          label: 'Dashboard',
          onTap: () {
            setKasirMode('portrait');
            controller.selectIndex(0);
          },
        ),
        SidebarXItem(
          icon: Icons.point_of_sale,
          label: 'Kasir',
          onTap: () {
            _showModeSelection(context);
          },
        ),
        SidebarXItem(
          icon: Icons.account_balance,
          label: 'Accounting',
          onTap: () {
            setKasirMode('portrait');
            controller.selectIndex(2);
          },
        ),
        SidebarXItem(
          icon: Icons.storage,
          label: 'Stockist',
          onTap: () {
            setKasirMode('portrait');
            controller.selectIndex(3);
          },
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () {
            setKasirMode('portrait');
            controller.selectIndex(4);
          },
        ),
        SidebarXItem(
          icon: Icons.logout,
          label: 'Log Out',
          onTap: () {
            debugPrint('Log Out');
          },
        ),
      ],
    );
  }

  void _showModeSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Mode'),
          content: const Text('Choose the mode for the Kasir page:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setKasirMode('portrait');
                controller.selectIndex(1);
                debugPrint('Portrait mode selected');
              },
              child: const Text('Portrait (HP)'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setKasirMode('landscape');
                controller.selectIndex(1);
                debugPrint('Landscape mode selected');
              },
              child: const Text('Landscape (Tablet)'),
            ),
          ],
        );
      },
    );
  }
}

const primaryColor = Color(0xFFFC1200);
const canvasColor = Color(0xFFF5F5F5); // Light canvas color
const scaffoldBackgroundColor = Color(0xFFFFFFFF); // White background
const accentCanvasColor = Color(0xFFE0E0E0);
const white = Colors.black; // Text color for better contrast on light background
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: Colors.black.withOpacity(0.3), height: 1);