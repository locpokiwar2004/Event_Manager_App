import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Save user data after login/signup
  static Future<void> saveUserData({
    required String token,
    required String email,
    required String name,
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userIdKey, userId);
  }

  // Get user data
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString(_tokenKey),
      'email': prefs.getString(_userEmailKey),
      'name': prefs.getString(_userNameKey),
      'userId': prefs.getString(_userIdKey),
    };
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userIdKey);
  }
}
