import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/core/cache/cache_keys.dart';

abstract class CacheData
{
  static bool? _firstTime;
  static String? _userType;
  static String? _userEmail;
  static String? _username;
  static String? _parentName;
  static String? _parentPhotoPath;
  static bool? _isLoggedIn;
  static bool? _isRegistrationComplete;

  // Getters
  static bool? get firstTime => _firstTime;
  static String? get userType => _userType;
  static String? get userEmail => _userEmail;
  static String? get username => _username;
  static String? get parentName => _parentName;
  static String? get parentPhotoPath => _parentPhotoPath;
  static bool? get isLoggedIn => _isLoggedIn;
  static bool? get isRegistrationComplete => _isRegistrationComplete;

  // Setters
  static Future<void> setFirstTime(bool value) async {
    try {
      _firstTime = value;
      await CacheHelper.saveData(key: CacheKeys.firstTime, value: value);
    } catch (e) {
      print('Error setting first time: $e');
      throw Exception('Failed to set first time status: $e');
    }
  }

  static Future<void> setUserType(String value) async {
    try {
      if (value.isEmpty) {
        throw Exception('User type cannot be empty');
      }
      _userType = value;
      await CacheHelper.saveData(key: CacheKeys.userType, value: value);
    } catch (e) {
      print('Error setting user type: $e');
      throw Exception('Failed to set user type: $e');
    }
  }

  static Future<void> setUserEmail(String value) async {
    try {
      if (value.isEmpty) {
        throw Exception('Email cannot be empty');
      }
      _userEmail = value;
      await CacheHelper.saveData(key: CacheKeys.userEmail, value: value);
    } catch (e) {
      print('Error setting user email: $e');
      throw Exception('Failed to set user email: $e');
    }
  }

  static Future<void> setUsername(String value) async {
    try {
      if (value.isEmpty) {
        throw Exception('Username cannot be empty');
      }
      _username = value;
      await CacheHelper.saveData(key: CacheKeys.username, value: value);
    } catch (e) {
      print('Error setting username: $e');
      throw Exception('Failed to set username: $e');
    }
  }

  static Future<void> setParentName(String value) async {
    try {
      if (value.isEmpty) {
        throw Exception('Parent name cannot be empty');
      }
      _parentName = value;
      await CacheHelper.saveData(key: CacheKeys.parentName, value: value);
    } catch (e) {
      print('Error setting parent name: $e');
      throw Exception('Failed to set parent name: $e');
    }
  }

  static Future<void> setParentPhotoPath(String value) async {
    try {
      if (value.isEmpty) {
        throw Exception('Photo path cannot be empty');
      }
      _parentPhotoPath = value;
      await CacheHelper.saveData(key: CacheKeys.parentPhotoPath, value: value);
    } catch (e) {
      print('Error setting parent photo path: $e');
      throw Exception('Failed to set parent photo path: $e');
    }
  }

  static Future<void> setLoggedIn(bool value) async {
    try {
      _isLoggedIn = value;
      await CacheHelper.saveData(key: CacheKeys.isLoggedIn, value: value);
    } catch (e) {
      print('Error setting login status: $e');
      throw Exception('Failed to set login status: $e');
    }
  }

  static Future<void> setRegistrationComplete(bool value) async {
    try {
      _isRegistrationComplete = value;
      await CacheHelper.saveData(key: CacheKeys.isRegistrationComplete, value: value);
    } catch (e) {
      print('Error setting registration completion status: $e');
      throw Exception('Failed to set registration completion status: $e');
    }
  }

  // Load all data from cache
  static Future<void> loadFromCache() async {
    try {
      _firstTime = CacheHelper.getData(key: CacheKeys.firstTime);
      _userType = CacheHelper.getData(key: CacheKeys.userType);
      _userEmail = CacheHelper.getData(key: CacheKeys.userEmail);
      _username = CacheHelper.getData(key: CacheKeys.username);
      _parentName = CacheHelper.getData(key: CacheKeys.parentName);
      _parentPhotoPath = CacheHelper.getData(key: CacheKeys.parentPhotoPath);
      _isLoggedIn = CacheHelper.getData(key: CacheKeys.isLoggedIn);
      _isRegistrationComplete = CacheHelper.getData(key: CacheKeys.isRegistrationComplete);
    } catch (e) {
      print('Error loading data from cache: $e');
      throw Exception('Failed to load data from cache: $e');
    }
  }

  // Clear all data
  static Future<void> clearAll() async {
    try {
      await CacheHelper.clearAllData();
      _firstTime = null;
      _userType = null;
      _userEmail = null;
      _username = null;
      _parentName = null;
      _parentPhotoPath = null;
      _isLoggedIn = null;
      _isRegistrationComplete = null;
    } catch (e) {
      print('Error clearing cache data: $e');
      throw Exception('Failed to clear cache data: $e');
    }
  }

  // Check if user is logged in
  static Future<bool> checkLoginStatus() async {
    try {
      await loadFromCache();
      return _isLoggedIn ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Check if registration is complete
  static Future<bool> checkRegistrationStatus() async {
    try {
      await loadFromCache();
      return _isRegistrationComplete ?? false;
    } catch (e) {
      print('Error checking registration status: $e');
      return false;
    }
  }

  // Check if user needs to complete registration
  static Future<bool> needsRegistration() async {
    try {
      await loadFromCache();
      return _userType != null && !(_isRegistrationComplete ?? false);
    } catch (e) {
      print('Error checking registration needs: $e');
      return false;
    }
  }
}