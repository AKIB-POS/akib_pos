import 'package:flutter/material.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:flutter_svg/svg.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: true,
      minimum: EdgeInsets.only(left: 16),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          leading: IconButton(
            icon: SvgPicture.asset(
              "assets/icons/ic_burger_menu.svg",
              
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        drawer: MyDrawer(),
        body: const Center(
          child: Text('Welcome to Dashboard'),
        ),
      ),
    );
  }
}
