import 'package:akib_pos/features/cashier/presentation/widgets/left_body.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/right_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/app_bar_content.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/category_drop_down.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/menu_grid.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/sub_category_list.dart';


class CashierPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      drawer: MyDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
        elevation: 0,
        flexibleSpace: AppBarContent(),
      ),
      body: Row(
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
      ),
    );
  }
}

