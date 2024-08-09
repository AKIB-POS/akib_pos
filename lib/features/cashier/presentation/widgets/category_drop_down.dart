import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CategoryDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> categoryItems = [
    {'value': 'semua_kategori', 'label': 'Semua Kategori', 'count': 10},
    {'value': 'makanan', 'label': 'Makanan', 'count': 8},
    {'value': 'minuman', 'label': 'Minuman', 'count': 5},
    {'value': 'favorit', 'label': 'Favorit', 'count': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: GlobalKey<FormState>(),
      child: BlocBuilder<CashierCubit, CashierState>(
        builder: (context, state) {
          return DropdownButtonFormField2<String>(
            isExpanded: true,
            value: state.selectedCategory,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: categoryItems
                .map((item) => DropdownMenuItem<String>(
                      value: item['value'] as String,
                      child: _buildDropdownItem(
                        item['label'] as String,
                        item['count'] as int,
                        state.selectedCategory == item['value'],
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Please select a category.';
              }
              return null;
            },
            onChanged: (value) {
              context.read<CashierCubit>().updateCategory(value!);
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              elevation: 1,
              scrollbarTheme: const ScrollbarThemeData(thumbColor: WidgetStateColor.transparent),
              maxHeight: 200,
              width: 30.w, // Set the dropdown width
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
            selectedItemBuilder: (BuildContext context) {
              return categoryItems.map((item) {
                return Text(
                  item['label'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                );
              }).toList();
            },
          );
        },
      ),
    );
  }


  Widget _buildDropdownItem(String label, int count, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryBackgorund.withOpacity(0.8) : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: AppColors.primaryMain,
                size: 20,
              ),
              SizedBox(width: 8.0),
              Text( label.length > 10 ? label.substring(0, 10)+'...' : label, style: AppTextStyle.headline6),
            ],
          ),
          Text('$count', style: AppTextStyle.headline6),
        ],
      ),
    );
  }
}