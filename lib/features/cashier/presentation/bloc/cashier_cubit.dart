import 'package:flutter_bloc/flutter_bloc.dart';

class CashierCubit extends Cubit<CashierState> {
  CashierCubit() : super(CashierState());

  void updateSearchText(String newText) {
    emit(state.copyWith(searchText: newText, selectedSubCategory: ''));
  }

  void updateCategory(String category) {
    emit(state.copyWith(selectedCategory: category, selectedSubCategory: ''));
  }

  void updateSubCategory(String subCategory) {
    emit(state.copyWith(selectedSubCategory: subCategory, searchText: ''));
  }
}

class CashierState {
  final String searchText;
  final String selectedCategory;
  final String selectedSubCategory;

  CashierState({
    this.searchText = '',
    this.selectedCategory = 'semua_kategori',
    this.selectedSubCategory = '',
  });

  CashierState copyWith({
    String? searchText,
    String? selectedCategory,
    String? selectedSubCategory,
  }) {
    return CashierState(
      searchText: searchText ?? this.searchText,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
    );
  }
}
