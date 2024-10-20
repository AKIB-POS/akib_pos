import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:akib_pos/features/auth/presentation/pages/auth_page.dart';
import 'package:akib_pos/features/home/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

class MyDrawer extends StatelessWidget {
  final List<String> menuTitles = ["Dashboard", "Kasir", "HRD", "Akunting", "Stockist", "Settings"];
  final List<String> iconTitles = ["assets/icons/ic_dashboard.svg", "assets/icons/ic_kasir.svg", "assets/icons/ic_hrd.svg", "assets/icons/ic_akunting.svg", "assets/icons/ic_stockist.svg", "assets/icons/ic_pengaturan.svg"];

  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  
  @override
  Widget build(BuildContext context) {
    MobilePermissions? mobilePermissions = _authSharedPref.getMobilePermissions();

    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          // Drawer Header
          CustomDrawerHeader(
            cafeName: _authSharedPref.getCompanyName() ?? "",
            ownerName: _authSharedPref.getEmployeeName() ?? "",
            cafeInitials: getInitials(_authSharedPref.getCompanyName() ?? ""),
            iconPath: "assets/icons/ic_app.svg",
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: [
                // Dashboard
                // if (mobilePermissions?.dashboard.isNotEmpty ?? false)
                  _buildMenuItem(context, "Dashboard", "assets/icons/ic_dashboard.svg", 0),
                
                // Kasir
                if(mobilePermissions?.cashier != null)
                  _buildMenuItem(context, "Kasir", "assets/icons/ic_kasir.svg", 1),

                // HRD - Hidden if mobilePermissions.hrd is empty
                if (mobilePermissions?.hrd.isNotEmpty ?? false)
                  _buildMenuItem(context, "HRD", "assets/icons/ic_hrd.svg", 2),

                // Akunting
                if (mobilePermissions?.accounting.isNotEmpty ?? false)
                  _buildMenuItem(context, "Akunting", "assets/icons/ic_akunting.svg", 3),

                // Stockist
                if (mobilePermissions?.stockist.isNotEmpty ?? false)
                  _buildMenuItem(context, "Stockist", "assets/icons/ic_stockist.svg", 4),

                // Settings
                _buildMenuItem(context, "Settings", "assets/icons/ic_pengaturan.svg", 5),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await _authSharedPref.clearLoginResponse(); // Clear login data
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AuthPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
  Widget _buildMenuItem(BuildContext context, String title, String iconPath, int index) {
    bool isSelected = BlocProvider.of<NavigationCubit>(context).state == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          tileColor: isSelected ? AppColors.primaryBackgorund : null,
          selected: isSelected,
          selectedTileColor: AppColors.primaryBackgorund.withOpacity(0.8),
          selectedColor: AppColors.primaryMain,
          title: Text(title),
          leading: SvgPicture.asset(
            iconPath,
            width: 2.h,
            height: 2.h,
            colorFilter: isSelected
                ? const ColorFilter.mode(AppColors.primaryMain, BlendMode.srcIn)
                : const ColorFilter.mode(AppColors.textGrey600, BlendMode.srcIn),
          ),
          onTap: () {
            BlocProvider.of<NavigationCubit>(context).navigateTo(index);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  String getInitials(String name) {
    List<String> words = name.split(" ");
    String initials = "";
    for (var word in words) {
      if (word.isNotEmpty) {
        initials += word[0];
      }
      if (initials.length == 2) {
        break;
      }
    }
    return initials;
  }
}

class CustomDrawerHeader extends StatelessWidget {
  final String cafeName;
  final String ownerName;
  final String cafeInitials;
  final String iconPath;

  CustomDrawerHeader({
    required this.cafeName,
    required this.ownerName,
    required this.cafeInitials,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: DrawerHeader(
        padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(244, 96, 63, 1),
              Color.fromRGBO(190, 54, 23, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath, // Replace with your icon asset
              height: 38,
              width: 38,
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(254, 244, 242, 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      cafeInitials,
                      style: TextStyle(
                        color: Color.fromRGBO(244, 96, 63, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cafeName,
                          style: AppTextStyle.headline6.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          ownerName,
                          style: AppTextStyle.body4.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}