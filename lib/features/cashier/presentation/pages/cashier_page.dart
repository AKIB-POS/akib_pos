
import 'package:akib_pos/features/cashier/presentation/widgets/app_bar_content.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/category_drop_down.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/menu_grid.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/sub_category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';

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
      body: BlocBuilder<CashierCubit, CashierState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CashierCubit>().loadData();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<CashierCubit>().loadData();
            },
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, left: 16, right: 0),
                    color: AppColors.backgroundGrey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CategoryDropdown(),
                            ),
                            Expanded(
                              flex: 7,
                              child: BlocBuilder<CashierCubit, CashierState>(
                                builder: (context, state) {
                                  return state.selectedCategory != 0
                                      ? SubCategoryList(
                                          categoryId: state.selectedCategory)
                                      : SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: MenuGrid(),
                        ),
                      ],
                    ),
                  ),
                ),
                bodyRight(),
              ],
            ),
          );
        },
      ),
    );
  }



  Expanded bodyRight() {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          ],
        ),
      ),
    );
  }

}