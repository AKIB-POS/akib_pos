import 'package:flutter/material.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        // Pastikan tidak ada duplikasi ikon menu di sini
      ),
      drawer: MyDrawer(),
      body: const Center(
        child: Text('Welcome to Dashboard'),
      ),
    );
  }
}
