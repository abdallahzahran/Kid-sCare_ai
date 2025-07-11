import 'dart:convert';
import 'package:flutter/material.dart'; // import this for ValueNotifier
import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/core/cache/cache_keys.dart';

class KidsService {
  static final KidsService _instance = KidsService._internal();
  factory KidsService() => _instance;
  KidsService._internal() {
    loadFromCache(); // Load data when the service is initialized
  }

  String? _userEmail;
  String? _userName;
  String? _parentName;
  String? _parentPhotoPath;
  // Change _kids to be managed by ValueNotifier
  final ValueNotifier<List<Map<String, String>>> _kidsNotifier = ValueNotifier([]);
  int _firstKidIndex = 0;

  // Getter for unmodifiable kids list (now from the notifier)
  List<Map<String, String>> get kids => List.unmodifiable(_kidsNotifier.value);

  // Expose the ValueNotifier for UI listeners
  ValueNotifier<List<Map<String, String>>> get kidsNotifier => _kidsNotifier;

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
    // Load kids for this user when email is set, and update notifier
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

    // Create a new list to trigger ValueNotifier update
    final updatedKids = List<Map<String, String>>.from(_kidsNotifier.value)..add(kid);
    _kidsNotifier.value = updatedKids; // Update the notifier's value
    await _saveKidsToCache();
  }

  // Save kids to cache
  Future<void> _saveKidsToCache() async {
    if (_userEmail == null) {
      throw Exception('User email must be set before saving kids');
    }
    try {
      final kidsJson = jsonEncode(_kidsNotifier.value); // Encode from notifier's value
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
        // Update the notifier's value directly
        _kidsNotifier.value = decodedKids.map((kid) => Map<String, String>.from(kid)).toList();
      } else {
        _kidsNotifier.value = []; // Clear list if no kids found
      }

      // Load first kid index
      final firstKidIndexStr = await CacheHelper.getData(key: 'first_kid_$email') as String?;
      if (firstKidIndexStr != null) {
        _firstKidIndex = int.parse(firstKidIndexStr);
      } else {
        _firstKidIndex = 0; // Reset if no index found
      }
      // Ensure the firstKidIndex is valid if kids were just loaded/cleared
      if (_firstKidIndex >= _kidsNotifier.value.length) {
        _firstKidIndex = _kidsNotifier.value.isEmpty ? 0 : _kidsNotifier.value.length - 1;
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
    if (index < 0 || index >= _kidsNotifier.value.length) {
      throw Exception('Invalid kid index');
    }
    _firstKidIndex = index;
    await CacheHelper.saveData(
      key: 'first_kid_${_userEmail}',
      value: index.toString(),
    );
    // You might want to trigger a UI update here if changing the selected kid affects other parts of the UI
    // that don't directly listen to kidsNotifier but rely on firstKidIndex.
    // For now, assume the UI managing the selected kid will handle its own setState.
  }

  // Get first kid
  Map<String, String>? getFirstKid() {
    if (_kidsNotifier.value.isEmpty) return null;
    return _kidsNotifier.value[_firstKidIndex];
  }

  // Clear all data for current user
  Future<void> clearAll() async {
    if (_userEmail != null) {
      await CacheHelper.removeData(key: 'kids_${_userEmail}');
      await CacheHelper.removeData(key: 'first_kid_${_userEmail}');
    }
    _kidsNotifier.value = []; // Clear the notifier's list
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
    print('Kids List Length: ${_kidsNotifier.value.length}');
    print('Index to delete: $index');

    if (_userEmail == null) {
      print('Error: User email is not set');
      return false;
    }

    if (index < 0 || index >= _kidsNotifier.value.length) {
      print('Error: Invalid index $index for kids list of length ${_kidsNotifier.value.length}');
      return false;
    }

    if (_kidsNotifier.value.length <= 1) {
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
    if (index < 0 || index >= _kidsNotifier.value.length) {
      throw Exception('Invalid kid index');
    }

    // Create a new list to trigger ValueNotifier update
    final updatedKids = List<Map<String, String>>.from(_kidsNotifier.value)..removeAt(index);
    _kidsNotifier.value = updatedKids; // Update the notifier's value

    if (_firstKidIndex >= _kidsNotifier.value.length) {
      _firstKidIndex = _kidsNotifier.value.isEmpty ? 0 : _kidsNotifier.value.length - 1;
    }
    await _saveKidsToCache();
    print('Kid deleted successfully');
  }

  // Update a specific kid
  Future<void> updateKid(int index, Map<String, String> kid) async {
    if (_userEmail == null) {
      throw Exception('User email must be set before updating kid');
    }
    if (index < 0 || index >= _kidsNotifier.value.length) {
      throw Exception('Invalid kid index');
    }
    if (!kid.containsKey('name') || !kid.containsKey('email') || !kid.containsKey('age')) {
      throw Exception('Kid data must contain name, email, and age');
    }

    // Create a new list to trigger ValueNotifier update
    final updatedKids = List<Map<String, String>>.from(_kidsNotifier.value);
    updatedKids[index] = kid;
    _kidsNotifier.value = updatedKids; // Update the notifier's value
    await _saveKidsToCache();
  }
}