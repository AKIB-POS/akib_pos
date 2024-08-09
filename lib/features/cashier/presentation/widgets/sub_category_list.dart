import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';

class SubCategoryList extends StatelessWidget {
  final String category;

  final Map<String, List<Map<String, dynamic>>> subCategoryItems = {
    'makanan': [
      {'label': 'Aneka Nasi', 'count': 5},
      {'label': 'Aneka Ayam', 'count': 3},
      {'label': 'Aneka Mie', 'count': 1},
    ],
    'minuman': [
      {'label': 'Teh', 'count': 5},
      {'label': 'Kopi', 'count': 3},
    ],
    'favorit': [
      {'label': 'Favorit 1', 'count': 2},
      {'label': 'Favorit 2', 'count': 4},
    ],
  };

  SubCategoryList({required this.category});

  @override
  Widget build(BuildContext context) {
    final subCategories = subCategoryItems[category]!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: subCategories
            .map((subCategory) => GestureDetector(
                  onTap: () {
                    context
                        .read<CashierCubit>()
                        .updateSubCategory(subCategory['label']);
                  },
                  child: BlocBuilder<CashierCubit, CashierState>(
                    builder: (context, state) {
                      final isSelected =
                          state.selectedSubCategory == subCategory['label'];
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
                              subCategory['label'] as String,
                              style: AppTextStyle.headline6.copyWith(color: isSelected ? AppColors.primaryMain : AppColors.textGrey800),
                            ),
                            Text(
                              '${subCategory['count']} Item',
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
  }
}