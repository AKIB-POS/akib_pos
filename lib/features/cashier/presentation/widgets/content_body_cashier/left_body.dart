import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/category_drop_down.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/menu_grid.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/sub_category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeftBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashierCubit, CashierState>(
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
                              ? SubCategoryList(categoryId: state.selectedCategory)
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
        );
      },
    );
  }
}
