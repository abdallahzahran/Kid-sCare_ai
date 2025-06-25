import 'dart:convert';
import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/core/cache/cache_keys.dart';

class KidsService {
  static final KidsService _instance = KidsService._internal();
  factory KidsService() => _instance;
  KidsService._internal();

  String? _userEmail;
  String? _userName;
  String? _parentName;
  String? _parentPhotoPath;
  final List<Map<String, String>> _kids = [];
  int _firstKidIndex = 0;

  // Getter for unmodifiable kids list
  List<Map<String, String>> get kids => List.unmodifiable(_kids);

  // Getter for first kid index
  int get firstKidIndex => _firstKidIndex;

  // Getter for user email
  String? get userEmail => _userEmail;

  // Getter for user name
  String? get userName => _userName;

  // Getter for parent name
  String? get parentName => _parentName;

  // Getter for parent photo path
  String? get parentPhotoPath => _parentPhotoPath;

  // Setter for user email
  Future<void> setUserEmail(String email) async {
    if (email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    _userEmail = email;
    await CacheHelper.saveData(key: CacheKeys.userEmail, value: email);
    // Load kids for this user when email is set
    await loadKidsForUser(email);
  }

  // Setter for user name
  Future<void> setUserName(String name) async {
    if (name.isEmpty) {
      throw Exception('Name cannot be empty');
    }
    _userName = name;
    await CacheHelper.saveData(key: CacheKeys.userName, value: name);
  }

  // Setter for parent name
  Future<void> setParentName(String name) async {
    if (name.isEmpty) {
      throw Exception('Parent name cannot be empty');
    }
    _parentName = name;
    await CacheHelper.saveData(key: CacheKeys.parentName, value: name);
  }

  // Setter for parent photo path
  Future<void> setParentPhotoPath(String path) async {
    if (path.isEmpty) {
      throw Exception('Photo path cannot be empty');
    }
    _parentPhotoPath = path;
    await CacheHelper.saveData(key: CacheKeys.parentPhotoPath, value: path);
  }

  // Add a new kid
  Future<void> addKid(Map<String, String> kid) async {
    if (_userEmail == null) {
      throw Exception('User email must be set before adding kids');
    }
    if (kid.isEmpty) {
      throw Exception('Kid data cannot be empty');
    }
    if (!kid.containsKey('name') || !kid.containsKey('email') || !kid.containsKey('age')) {
      throw Exception('Kid data must contain name, email, and age');
    }
    _kids.add(kid);
    await _saveKidsToCache();
  }

  // Save kids to cache
  Future<void> _saveKidsToCache() async {
    if (_userEmail == null) {
      throw Exception('User email must be set before saving kids');
    }
    try {
      final kidsJson = jsonEncode(_kids);
      await CacheHelper.saveData(
        key: 'kids_${_userEmail}',
        value: kidsJson,
      );
      // Save first kid index
      await CacheHelper.saveData(
        key: 'first_kid_${_userEmail}',
        value: _firstKidIndex.toString(),
      );
    } catch (e) {
      throw Exception('Failed to save kids to cache: $e');
    }
  }

  // Load kids for specific user
  Future<void> loadKidsForUser(String email) async {
    try {
      final kidsJson = await CacheHelper.getData(key: 'kids_$email') as String?;
      if (kidsJson != null) {
        final List<dynamic> decodedKids = jsonDecode(kidsJson);
        _kids.clear();
        _kids.addAll(decodedKids.map((kid) => Map<String, String>.from(kid)));
      }

      // Load first kid index
      final firstKidIndexStr = await CacheHelper.getData(key: 'first_kid_$email') as String?;
      if (firstKidIndexStr != null) {
        _firstKidIndex = int.parse(firstKidIndexStr);
      }
    } catch (e) {
      throw Exception('Failed to load kids for user: $e');
    }
  }

  // Load data from cache
  Future<void> loadFromCache() async {
    try {
      _userEmail = await CacheHelper.getData(key: CacheKeys.userEmail) as String?;
      _userName = await CacheHelper.getData(key: CacheKeys.userName) as String?;
      _parentName = await CacheHelper.getData(key: CacheKeys.parentName) as String?;
      _parentPhotoPath = await CacheHelper.getData(key: CacheKeys.parentPhotoPath) as String?;
      
      if (_userEmail != null) {
        await loadKidsForUser(_userEmail!);
      }
    } catch (e) {
      throw Exception('Failed to load data from cache: $e');
    }
  }

  // Update first kid index
  Future<void> updateFirstKid(int index) async {
    if (_userEmail == null) {
      throw Exception('User email must be set before updating first kid');
    }
    if (index < 0 || index >= _kids.length) {
      throw Exception('Invalid kid index');
    }
    _firstKidIndex = index;
    await CacheHelper.saveData(
      key: 'first_kid_${_userEmail}',
      value: index.toString(),
    );
  }

  // Get first kid
  Map<String, String>? getFirstKid() {
    if (_kids.isEmpty) return null;
    return _kids[_firstKidIndex];
  }

  // Clear all data for current user
  Future<void> clearAll() async {
    if (_userEmail != null) {
      await CacheHelper.removeData(key: 'kids_${_userEmail}');
      await CacheHelper.removeData(key: 'first_kid_${_userEmail}');
    }
    _kids.clear();
    _userEmail = null;
    _userName = null;
    _parentName = null;
    _parentPhotoPath = null;
    _firstKidIndex = 0;
    
    await CacheHelper.removeData(key: CacheKeys.userEmail);
    await CacheHelper.removeData(key: CacheKeys.userName);
    await CacheHelper.removeData(key: CacheKeys.parentName);
    await CacheHelper.removeData(key: CacheKeys.parentPhotoPath);
  }

  // Check if a kid can be deleted
  bool canDeleteKid(int index) {
    print('Checking if kid can be deleted:');
    print('User Email: $_userEmail');
    print('Kids List Length: ${_kids.length}');
    print('Index to delete: $index');
    
    if (_userEmail == null) {
      print('Error: User email is not set');
      return false;
    }
    
    if (index < 0 || index >= _kids.length) {
      print('Error: Invalid index $index for kids list of length ${_kids.length}');
      return false;
    }
    
    if (_kids.length <= 1) {
      print('Error: Cannot delete the only kid');
      return false;
    }
    
    print('Kid can be deleted');
    return true;
  }

  // Delete a specific kid
  Future<void> deleteKid(int index) async {
    print('Attempting to delete kid:');
    print('User Email: $_userEmail');
    print('Index to delete: $index');
    
    if (_userEmail == null) {
      throw Exception('User email must be set before deleting kid');
    }
    if (index < 0 || index >= _kids.length) {
      throw Exception('Invalid kid index');
    }
    
    _kids.removeAt(index);
    if (_firstKidIndex >= _kids.length) {
      _firstKidIndex = _kids.isEmpty ? 0 : _kids.length - 1;
    }
    await _saveKidsToCache();
    print('Kid deleted successfully');
  }

  // Update a specific kid
  Future<void> updateKid(int index, Map<String, String> kid) async {
    if (_userEmail == null) {
      throw Exception('User email must be set before updating kid');
    }
    if (index < 0 || index >= _kids.length) {
      throw Exception('Invalid kid index');
    }
    if (!kid.containsKey('name') || !kid.containsKey('email') || !kid.containsKey('age')) {
      throw Exception('Kid data must contain name, email, and age');
    }
    _kids[index] = kid;
    await _saveKidsToCache();
  }
} 