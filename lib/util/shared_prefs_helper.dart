import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _tokenKey = 'TOKEN';

  final SharedPreferences sharedPreferences;

  SharedPrefsHelper(this.sharedPreferences);

  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  String getToken() {
    return sharedPreferences.getString(_tokenKey) ?? '123';
  }
}
