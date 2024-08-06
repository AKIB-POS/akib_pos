import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/home/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class MyDrawer extends StatelessWidget {
  final List<String> menuTitles = ["Kasir","Dashboard","HRD", "Stockist", "Settings"];
  final List<String> iconTitles = [ "assets/icons/ic_kasir.svg", "assets/icons/ic_dashboard.svg", "assets/icons/ic_hrd.svg", "assets/icons/ic_stockist.svg", "assets/icons/ic_pengaturan.svg"];
  final String cafeName = "Cafe Arrazzaq";
  final String ownerName = "Fadhil Muhaimin";

  @override
  Widget build(BuildContext context) {
    String cafeInitials = getInitials(cafeName);
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          CustomDrawerHeader(
            cafeName: cafeName,
            ownerName: ownerName,
            cafeInitials: cafeInitials,
            iconPath: "assets/icons/ic_app.svg", // Replace with your icon asset
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0), // Padding for the entire list
              itemCount: menuTitles.length,
              itemBuilder: (BuildContext context, int index) {
                bool isSelected = BlocProvider.of<NavigationCubit>(context).state == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15), // Padding between each ListTile
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners for the ListTile
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      tileColor: isSelected ? AppColors.primaryBackgorund : null,
                      selected: isSelected,
                      selectedTileColor: AppColors.primaryBackgorund,
                      selectedColor: AppColors.primaryMain,
                      title: Text(menuTitles[index]),
                      leading: SvgPicture.asset(
                        iconTitles[index],
                        width: 32,
                        height: 32,
                        colorFilter: isSelected ? const ColorFilter.mode(AppColors.primaryMain, BlendMode.srcIn) : const ColorFilter.mode(AppColors.textGrey600, BlendMode.srcIn),
                      ),
                      onTap: () {
                        BlocProvider.of<NavigationCubit>(context).navigateTo(index);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Handle logout logic
            },
          ),
        ],
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
      height : 250,
      child: DrawerHeader(
        padding: EdgeInsets.only(bottom: 20,left: 20,right: 20),
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
              height: 48,
              width: 48,
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          ownerName,
                          style: TextStyle(
                            color: Colors.white,
                          ),
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
