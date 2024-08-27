import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/accounting_grid_menu.dart';
import 'package:akib_pos/features/accounting/presentation/widgets/appbar_accounting_page.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AccountingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundGrey,
      drawer: MyDrawer(),
       appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h), // Tinggi AppBar ditambah di sini
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false, // Menghilangkan tombol default menu drawer
          backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
          elevation: 0,
          flexibleSpace: SafeArea(
            child: AppBarAccountingContent(),
          ),
        ),
      ),
      body: AccountingGridMenu(),
    );
  }
}

