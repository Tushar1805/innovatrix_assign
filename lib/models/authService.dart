import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Key for storing the session token
  static const String _sessionTokenKey = 'session_token';

  // Store the session token locally
  Future<void> setSessionToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionTokenKey, token);
  }

  // Retrieve the session token
  static Future<String?> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_sessionTokenKey);
    if (token != null) {
      return token;
    }
    return null;
  }

  // Clear the session token
  static Future<void> clearSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionTokenKey);
  }

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    final sessionToken = await getSessionToken();
    return sessionToken != null;
  }

  // Log the user out
  static Future<void> logout() async {
    await clearSessionToken();
    // Additional logout logic such as navigating to the login screen, etc.
  }
}
