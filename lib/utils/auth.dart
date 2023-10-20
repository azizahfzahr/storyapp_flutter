import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String authTokenKey = 'authToken';

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(authTokenKey);
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(authTokenKey);
  }

  static Future<void> saveAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(authTokenKey, token);
  }

  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
