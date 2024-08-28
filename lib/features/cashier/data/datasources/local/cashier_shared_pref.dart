import 'package:shared_preferences/shared_preferences.dart';

class CashierSharedPref {
  final SharedPreferences sharedPreferences;

  CashierSharedPref({required this.sharedPreferences});

  // Set apakah kasir sedang dibuka atau ditutup
  Future<void> setCashierIsOpen(bool isOpen) async {
    await sharedPreferences.setBool('cashier_is_open', isOpen);
  }

  // Dapatkan status kasir
  Future<bool> isCashierOpen() async {
    return sharedPreferences.getBool('cashier_is_open') ?? false;
  }

  // Bersihkan data kasir (jika diperlukan)
  Future<void> clearCashierData() async {
    await sharedPreferences.remove('cashier_is_open');
  }
}