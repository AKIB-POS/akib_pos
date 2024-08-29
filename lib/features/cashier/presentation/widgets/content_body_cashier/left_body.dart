import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/category_drop_down.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/menu_grid.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/open_cashier_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/sub_category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeftBody extends StatefulWidget {
  @override
  State<LeftBody> createState() => _LeftBodyState();
}

class _LeftBodyState extends State<LeftBody> {

  @override
  void initState() {
    context.read<CashierCubit>().loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashierCubit, CashierState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.error!, style: AppTextStyle.headline5),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMain,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  onPressed: () {
                    context.read<CashierCubit>().loadData();
                  },
                  child: const Text('Muat Ulang Data'),
                ),
              ],
            ),
          );
        }

        // Periksa status kasir hanya jika data sudah dimuat dan status tidak null
        if (state.cashRegisterStatus == "close") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return OpenCashierDialog();
              },
              barrierDismissible: false, // Tidak bisa ditutup dengan klik luar
            );
          });
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
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
