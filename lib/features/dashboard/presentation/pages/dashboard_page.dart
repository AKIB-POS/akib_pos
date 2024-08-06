import 'package:flutter/material.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:flutter_svg/svg.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: SvgPicture.asset("assets/icons/ic_burger_menu.svg"),
        // Pastikan tidak ada duplikasi ikon menu di sini
      ),
      drawer: MyDrawer(),
      body: const Center(
        child: Text('Welcome to Dashboard'),
      ),
    );
  }
}
