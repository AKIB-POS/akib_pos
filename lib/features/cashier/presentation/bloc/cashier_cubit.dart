import 'package:flutter_bloc/flutter_bloc.dart';

class CashierCubit extends Cubit<String> {
  CashierCubit() : super('');

  void updateSearchText(String newText) {
    emit(newText);
  }
}