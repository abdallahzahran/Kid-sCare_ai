import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheHelper
{
  static late SharedPreferences _prefs;

  static Future<void> init() async
  {
    _prefs = await SharedPreferences.getInstance();
  }

  // User Session Management
  static Future<void> saveUserSession({
    required String email,
    required String username,
    required bool isLoggedIn,
  }) async
  {
    await _prefs.setString('email', email);
    await _prefs.setString('username', username);
    await _prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Map<String, dynamic>? getUserSession() {
    if (!_prefs.containsKey('isLoggedIn')) return null;
    
    return {
      'email': _prefs.getString('email'),
      'username': _prefs.getString('username'),
      'isLoggedIn': _prefs.getBool('isLoggedIn'),
    };
  }

  static Future<void> clearUserSession() async {
    await _prefs.remove('email');
    await _prefs.remove('username');
    await _prefs.remove('isLoggedIn');
  }

  // Kids Data Management
  static Future<void> saveKidsData(List<Map<String, dynamic>> kids) async {
    final String encodedData = jsonEncode(kids);
    await _prefs.setString('kids_data', encodedData);
  }

  static List<Map<String, dynamic>> getKidsData() {
    final String? encodedData = _prefs.getString('kids_data');
    if (encodedData == null) return [];
    
    try {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error decoding kids data: $e');
      return [];
    }
  }

  // Parent Data Management
  static Future<void> saveParentName(String name) async {
    await _prefs.setString('parent_name', name);
  }

  static String? getParentName() {
    return _prefs.getString('parent_name');
  }

  static Future<void> saveParentPhotoPath(String path) async {
    await _prefs.setString('parent_photo_path', path);
  }

  static String? getParentPhotoPath() {
    return _prefs.getString('parent_photo_path');
  }

  // User Type Management
  static Future<void> saveUserType(String type) async {
    await _prefs.setString('user_type', type);
  }

  static String? getUserType() {
    return _prefs.getString('user_type');
  }

  // Theme Mode
  static Future<bool> saveThemeMode(bool isDark) async {
    return await saveData(key: 'isDarkMode', value: isDark);
  }

  static bool getThemeMode() {
    return getData(key: 'isDarkMode') ?? false;
  }

  // Language
  static Future<bool> saveLanguage(String languageCode) async {
    return await saveData(key: 'language', value: languageCode);
  }

  static String getLanguage() {
    return getData(key: 'language') ?? 'en';
  }

  // Generic Methods
  static Future<bool> saveData ({
    required String key,
    required dynamic value,
  }) async
  {
    if (value is String ) {
      return await _prefs.setString(key, value);
    }
    if (value is int ) {
      return await _prefs.setInt(key, value);
    }
    if (value is bool ) {
      return await _prefs.setBool(key, value);
    }
    if (value is double) {
      return await _prefs.setDouble(key, value);
    }
    return false;
  }

  static dynamic getData({required String key})
  {
    return _prefs.get(key);
  }

  static Future<bool> removeData
      ({
    required String key
  })async
  {
    return await _prefs.remove(key);
  }

  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}