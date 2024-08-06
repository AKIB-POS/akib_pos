import 'package:flutter_bloc/flutter_bloc.dart';

class CashierSearchCubit extends Cubit<String> {
  CashierSearchCubit() : super('');

  void updateSearchText(String newText) {
    emit(newText);
  }
}