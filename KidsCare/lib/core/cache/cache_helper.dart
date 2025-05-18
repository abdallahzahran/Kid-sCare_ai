import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  static late final SharedPreferences sharedPreferences ;
  static Future<void> init() async
  {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
      throw Exception('Failed to initialize SharedPreferences: $e');
    }
  }

  static Future<bool> saveData ({
    required String key,
    required dynamic value,
  }) async
  {
    try {
      if (value == null) {
        print('Warning: Attempting to save null value for key: $key');
        return false;
      }

      if (value is String ) {
        return await sharedPreferences.setString(key, value);
      }
      if (value is int ) {
        return await sharedPreferences.setInt(key, value);
      }
      if (value is bool ) {
        return await sharedPreferences.setBool(key, value);
      }
      if (value is double) {
        return await sharedPreferences.setDouble(key, value);
      }

      print('Warning: Unsupported value type for key: $key');
      return false;
    } catch (e) {
      print('Error saving data to SharedPreferences: $e');
      throw Exception('Failed to save data for key $key: $e');
    }
  }

  static dynamic getData({required String key})
  {
    try {
      if (!sharedPreferences.containsKey(key)) {
        print('Warning: Key not found in SharedPreferences: $key');
        return null;
      }
      return sharedPreferences.get(key);
    } catch (e) {
      print('Error getting data from SharedPreferences: $e');
      throw Exception('Failed to get data for key $key: $e');
    }
  }

  static Future<bool> removeData
      ({
    required String key
  })async
  {
    try {
      if (!sharedPreferences.containsKey(key)) {
        print('Warning: Attempting to remove non-existent key: $key');
        return false;
      }
      return await sharedPreferences.remove(key);
    } catch (e) {
      print('Error removing data from SharedPreferences: $e');
      throw Exception('Failed to remove data for key $key: $e');
    }
  }

  static Future<bool> clearAllData() async {
    try {
      return await sharedPreferences.clear();
    } catch (e) {
      print('Error clearing SharedPreferences: $e');
      throw Exception('Failed to clear SharedPreferences: $e');
    }
  }
}