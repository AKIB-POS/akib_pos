import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/tasking/employee_tasking_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/tasking/subordinate_tasking_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';

class ManagerTaskingMenu extends StatefulWidget {
  const ManagerTaskingMenu({super.key});

  @override
  State<ManagerTaskingMenu> createState() => _ManagerTaskingMenuState();
}

class _ManagerTaskingMenuState extends State<ManagerTaskingMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          "Tasking",
          style: AppTextStyle.headline5,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Utils.buildMenuItem(context, title: "Tasking Anda", onTap: () {
              Utils.navigateToPage(context, const EmployeeTaskingPage());
            },),
            SizedBox(height: 16,),
            Utils.buildMenuItem(context, title: "Tasking Bawahan", onTap: () {
              Utils.navigateToPage(context, SubOrdinateTaskingPage());
            },)
          ],
        ),
      ),
    );
  }
}
