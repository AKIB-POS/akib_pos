import 'package:akib_pos/features/home/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class MyDrawer extends StatelessWidget {
  final List<String> menuTitles = ["Dashboard", "Kasir", "HRD", "Stockist", "Settings"];
  final List<String> iconTitles = ["assets/icons/ic_dashboard.svg", "assets/icons/ic_kasir.svg", "assets/icons/ic_hrd.svg", "assets/icons/ic_stockist.svg", "assets/icons/ic_pengaturan.svg"];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(244, 96, 63, 1),
              // Future implementation: add some pattern background and images
            ),
            child: Container(height: 200), // Example height
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuTitles.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
  padding: const EdgeInsets.only(bottom: 20),
  child: ListTile(
    title: Text(menuTitles[index]),
    selected: BlocProvider.of<NavigationCubit>(context).state == index,
    selectedTileColor: Color.fromRGBO(254, 244, 242, 1),
    selectedColor: Color.fromRGBO(244, 96, 63, 1),
    leading: SvgPicture.asset(
      iconTitles[index],
      width: 32,
      height: 32,
      placeholderBuilder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(10.0),
        child: const CircularProgressIndicator(),
      ),

    ),
    onTap: () {
      BlocProvider.of<NavigationCubit>(context).navigateTo(index);
      Navigator.pop(context);
    },
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
}