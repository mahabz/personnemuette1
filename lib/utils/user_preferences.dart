import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // Keys
  static const _keyUserId = 'userId';
  static const _keyName = 'name';
  static const _keyEmail = 'email';
  static const _keyToken = 'token'; // Added for token management
  static const _keyRememberMe = 'rememberMe';
  static const _keyRememberedEmail = 'remembered_email';
  static const _keyRememberedPassword = 'remembered_password';
  static const _keyLanguage = 'language'; // Nouvelle clé pour la langue

  // Static instance of SharedPreferences
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user information
  static Future<void> saveUserInfo(
      String userId, String name, String email) async {
    await _prefs?.setString(_keyUserId, userId);
    await _prefs?.setString(_keyName, name); // Save the user's name
    await _prefs?.setString(_keyEmail, email);
  }

  // Save user token
  static Future<void> saveUserToken(String token) async {
    await _prefs?.setString(_keyToken, token);
  }

  // Get user name
  static Future<String?> getUserName() async {
    return _prefs?.getString(_keyName);
  }

  // Get user ID
  static Future<String?> getUserId() async {
    return _prefs?.getString(_keyUserId);
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    return _prefs?.getString(_keyEmail);
  }

  // Get user token
  static Future<String?> getUserToken() async {
    return _prefs?.getString(_keyToken);
  }

  // Get user ID synchronously (without async/await)
  static String? getUserIdSync() {
    return _prefs?.getString(_keyUserId);
  }

  // Clear user data (for logout)
  static Future<bool> clearUserData() async {
    await _prefs?.remove(_keyUserId);
    await _prefs?.remove(_keyName);
    await _prefs?.remove(_keyEmail);
    await _prefs?.remove(_keyToken); // Clear token on logout
    return true;
  }

  // Save remembered credentials when "Remember me" is checked
  static Future<void> saveRememberedCredentials(
      String email, String password, bool rememberMe) async {
    await _prefs?.setString(_keyRememberedEmail, email);
    await _prefs?.setString(_keyRememberedPassword, password);
    await _prefs?.setBool(_keyRememberMe, rememberMe);
  }

  // Get remembered credentials
  static Future<Map<String, dynamic>> getRememberedCredentials() async {
    return {
      'email': _prefs?.getString(_keyRememberedEmail) ?? '',
      'password': _prefs?.getString(_keyRememberedPassword) ?? '',
      'rememberMe': _prefs?.getBool(_keyRememberMe) ?? false,
    };
  }

  // Clear remembered credentials (useful when logging out)
  static Future<bool> clearRememberedCredentials() async {
    await _prefs?.remove(_keyRememberMe);
    await _prefs?.remove(_keyRememberedEmail);
    await _prefs?.remove(_keyRememberedPassword);
    return true;
  }

  // Save selected language
  static Future<void> saveLanguage(String languageCode) async {
    await _prefs?.setString(_keyLanguage, languageCode);
  }

  // Get the saved language
  static Future<String?> getLanguage() async {
    return _prefs?.getString(_keyLanguage);
  }

  // Clear the language preference
  static Future<bool> clearLanguage() async {
    await _prefs?.remove(_keyLanguage);
    return true;
  }
}
