import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationEvents { DashboardClickedEvent, CashierClickedEvent, HRDClickedEvent, StockistClickedEvent, SettingsClickedEvent }

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void navigateTo(int index) {
    emit(index);
  }
}