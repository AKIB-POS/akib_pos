import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _tokenKey = 'CASHIER_STATUS';

  final SharedPreferences sharedPreferences;

  SharedPrefsHelper(this.sharedPreferences);

}
