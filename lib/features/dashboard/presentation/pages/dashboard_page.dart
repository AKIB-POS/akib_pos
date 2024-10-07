import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/appbar_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
    drawer: MyDrawer(),
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.h),
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
