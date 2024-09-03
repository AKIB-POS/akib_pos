
import 'package:intl/intl.dart';
class Utils{

  static String formatCurrencyDouble(double input) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(input);
  }
  static String formatCurrency(String input) {
  int value = int.parse(input);
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(value);
}


  static String formatNumber(String input) {
  int value = int.parse(input);
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: '', // Menghilangkan simbol "Rp"
    decimalDigits: 0,
  );
  return formatter.format(value).trim(); // Menggunakan trim() untuk menghilangkan spasi ekstra
}

// Method untuk format angka dari double tanpa simbol "Rp"
static String formatNumberDouble(double input) {
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: '', // Menghilangkan simbol "Rp"
    decimalDigits: 0,
  );
  return formatter.format(input).trim(); // Menggunakan trim() untuk menghilangkan spasi ekstra
}
}

