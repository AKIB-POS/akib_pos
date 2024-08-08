import 'package:akib_pos/features/cashier/data/models/menu_item_exmpl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CashierCubit extends Cubit<CashierState> {
  CashierCubit() : super(CashierState(menuItems: dummyMenuItems));

  void updateSearchText(String newText) {
    emit(state.copyWith(searchText: newText, selectedSubCategory: ''));
  }

  void updateCategory(String category) {
    emit(state.copyWith(selectedCategory: category, selectedSubCategory: ''));
  }

  void updateSubCategory(String subCategory) {
    emit(state.copyWith(selectedSubCategory: subCategory, searchText: ''));
  }

  List<MenuItem> get filteredItems {
    final searchText = state.searchText.toLowerCase();
    final selectedCategory = state.selectedCategory;
    final selectedSubCategory = state.selectedSubCategory;

    return state.menuItems.where((item) {
      final matchesCategory = selectedCategory == 'semua_kategori' || item.category == selectedCategory;
      final matchesSubCategory = selectedSubCategory.isEmpty || item.subCategory == selectedSubCategory;
      final matchesSearch = item.name.toLowerCase().contains(searchText);

      return matchesCategory && matchesSubCategory && matchesSearch;
    }).toList();
  }
}

class CashierState {
  final String searchText;
  final String selectedCategory;
  final String selectedSubCategory;
  final List<MenuItem> menuItems;

  CashierState({
    this.searchText = '',
    this.selectedCategory = 'semua_kategori',
    this.selectedSubCategory = '',
    this.menuItems = const [],
  });

  CashierState copyWith({
    String? searchText,
    String? selectedCategory,
    String? selectedSubCategory,
    List<MenuItem>? menuItems,
  }) {
    return CashierState(
      searchText: searchText ?? this.searchText,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      menuItems: menuItems ?? this.menuItems,
    );
  }
}
