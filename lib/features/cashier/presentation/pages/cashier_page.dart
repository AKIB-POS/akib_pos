import 'package:akib_pos/features/cashier/data/datasources/local/cashier_shared_pref.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/left_body.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/open_cashier_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/right_body.dart';
import 'package:flutter/material.dart';
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/app_bar_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../common/util.dart';


class CashierPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: isLandscape(context) ? null : Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: AppColors.primaryMain,
          child: Icon(Icons.shopping_cart, color: AppColors.backgroundWhite,),
          onPressed: () {
            // Opens the end drawer
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundGrey,
      drawer: MyDrawer(),
      endDrawer: isLandscape(context) ? null : Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
        child: RightBody(),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
        elevation: 0,
        flexibleSpace: AppBarContent(),
        actions: [Container()],
      ),
      body: isLandscape(context) ? Row(
        children: [
          Expanded(
            flex: 5,
            child: LeftBody(),
          ),
          Expanded(
            flex: 3,
            child: RightBody(),
          ),
        ],
      ) : LeftBody(),
    );
  }  
}