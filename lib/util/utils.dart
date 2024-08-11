
import 'package:intl/intl.dart';
class Utils{
  static String formatCurrency(String input) {
  int value = int.parse(input);
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(value);
}

}