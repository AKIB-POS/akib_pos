import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

class AppbarDashboardPage extends StatelessWidget {
   AppbarDashboardPage({super.key});
   final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();
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
    return Padding(
      padding: isTablet ? const EdgeInsets.symmetric(vertical: 8) : const EdgeInsets.only(top:4,bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/ic_burger_menu.svg",
                  height: 6.5.h,
                  width: 6.5.w,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_authSharedPref.getEmployeeName() ?? "", style: AppTextStyle.headline5),
              SizedBox(
                height: 4,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.successMain,
                ),
                child: Text(
                  _authSharedPref.getRole() ?? "",
                  style: AppTextStyle.body3.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}