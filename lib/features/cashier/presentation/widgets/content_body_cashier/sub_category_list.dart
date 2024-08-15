import 'package:akib_pos/features/cashier/data/models/sub_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';

class SubCategoryList extends StatelessWidget {
  final int categoryId;

  SubCategoryList({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashierCubit, CashierState>(
      builder: (context, state) {
        final allSubCategories = [
          SubCategoryModel(id: 0, subCategoryName: 'Semua', count: state.menuItems.where((item) => item.categoryId == categoryId).length, categoryId: categoryId)
        ];
        final subCategories = allSubCategories + state.subCategories.where((subCategory) => subCategory.categoryId == categoryId).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: subCategories
                .map((subCategory) => GestureDetector(
                      onTap: () {
                        context.read<CashierCubit>().updateSubCategory(subCategory.id);
                      },
                      child: BlocBuilder<CashierCubit, CashierState>(
                        builder: (context, state) {
                          final isSelected = state.selectedSubCategory == subCategory.id;
                          return Container(
                            margin: EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.5),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryBackgorund
                                  : Colors.white,
                              border: isSelected ? Border.all(color: AppColors.primaryMain) : null,
                              borderRadius: BorderRadius.circular(8.0),
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
                                Text(
                                  subCategory.subCategoryName,
                                  style: AppTextStyle.headline6.copyWith(color: isSelected ? AppColors.primaryMain : AppColors.textGrey800),
                                ),
                                Text(
                                  '${subCategory.count} Item',
                                  style: AppTextStyle.body3.copyWith(color: AppColors.textGrey600),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
