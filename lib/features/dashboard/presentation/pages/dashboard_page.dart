import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/appbar_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class DashboardPage extends StatelessWidget {
   bool isTabletDevice(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    final aspectRatio = width / height;

    return aspectRatio >= 1.0 && width >= 600;
  }
  
  @override
  Widget build(BuildContext context) {
     bool isTablet = isTabletDevice(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
    drawer: MyDrawer(),
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: isTablet ? Size.fromHeight(8.h) : Size.fromHeight(10.h),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: AppbarDashboardPage(),
          ),
        ),
      ),
      body: const Center(
        child: Text('Welcome to Dashboard'),
      ),
    );
  }
}
