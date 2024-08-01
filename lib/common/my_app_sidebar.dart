import 'package:akib_pos/common/app_colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:sizer/sizer.dart';

class MyAppSidebar extends StatelessWidget {
  final SidebarXController controller;
  final Function(String) setKasirMode;
  final bool isSmallScreen;

  const MyAppSidebar({
    super.key,
    required this.controller,
    required this.setKasirMode,
    required this.isSmallScreen,
  });

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
        iconTheme: const IconThemeData(
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
        iconTheme: const IconThemeData(
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
            SizedBox(height:4.h),
            ClipOval(
              child: ExtendedImage.network(
                "https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                fit: BoxFit.cover,
                width: extended ? 100 : 7.h,
                height: extended ? 100 : 7.h,
              ),
            ),
            SizedBox(height:1.h),
            if (extended)
              const Column(
                children: [
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

