import 'package:kidscare/core/cache/cache_helper.dart';

class KidsService {
  static final KidsService _instance = KidsService._internal();
  factory KidsService() => _instance;
  KidsService._internal();

  final List<Map<String, String>> _kids = [];
  Map<String, String>? _firstKid;
  String? _userName;
  String? _parentName;
  String? _parentPhotoPath;

  List<Map<String, String>> get kids => _kids;
  Map<String, String>? get firstKid => _firstKid;
  String? get userName => _userName;
  String? get parentName => _parentName;
  String? get parentPhotoPath => _parentPhotoPath;

  void setUserName(String name) {
    _userName = name;
    CacheHelper.saveData(key: 'user_name', value: name);
  }

  void setParentName(String name) {
    _parentName = name;
    CacheHelper.saveData(key: 'parent_name', value: name);
  }

  void setParentPhotoPath(String path) {
    _parentPhotoPath = path;
    CacheHelper.saveData(key: 'parent_photo_path', value: path);
  }

  void addKid(Map<String, String> kid) {
    _kids.add(kid);
    if (_firstKid == null) {
      _firstKid = kid;
      // Store first kid info in cache
      CacheHelper.saveData(key: 'first_kid_name', value: kid['name'] ?? '');
      CacheHelper.saveData(key: 'first_kid_email', value: kid['email'] ?? '');
      CacheHelper.saveData(key: 'first_kid_age', value: kid['age'] ?? '');
    }
  }

  void updateKid(int index, Map<String, String> kid) {
    if (index >= 0 && index < _kids.length) {
      _kids[index] = kid;
      // If updating first kid, update cache
      if (index == 0) {
        _firstKid = kid;
        CacheHelper.saveData(key: 'first_kid_name', value: kid['name'] ?? '');
        CacheHelper.saveData(key: 'first_kid_email', value: kid['email'] ?? '');
        CacheHelper.saveData(key: 'first_kid_age', value: kid['age'] ?? '');
      }
    }
  }

  void updateFirstKid(int index) {
    if (index >= 0 && index < _kids.length) {
      _firstKid = _kids[index];
      // Update cache with new first kid info
      CacheHelper.saveData(key: 'first_kid_name', value: _kids[index]['name'] ?? '');
      CacheHelper.saveData(key: 'first_kid_email', value: _kids[index]['email'] ?? '');
      CacheHelper.saveData(key: 'first_kid_age', value: _kids[index]['age'] ?? '');
    }
  }

  void deleteKid(int index) {
    if (index >= 0 && index < _kids.length) {
      _kids.removeAt(index);
      // If deleting first kid, update first kid reference
      if (index == 0 && _kids.isNotEmpty) {
        _firstKid = _kids[0];
        CacheHelper.saveData(key: 'first_kid_name', value: _kids[0]['name'] ?? '');
        CacheHelper.saveData(key: 'first_kid_email', value: _kids[0]['email'] ?? '');
        CacheHelper.saveData(key: 'first_kid_age', value: _kids[0]['age'] ?? '');
      } else if (_kids.isEmpty) {
        _firstKid = null;
        CacheHelper.removeData(key: 'first_kid_name');
        CacheHelper.removeData(key: 'first_kid_email');
        CacheHelper.removeData(key: 'first_kid_age');
      }
    }
  }

  // Load data from cache on app start
  Future<void> loadFromCache() async {
    // Load first kid
    final name = CacheHelper.getData(key: 'first_kid_name');
    final email = CacheHelper.getData(key: 'first_kid_email');
    final age = CacheHelper.getData(key: 'first_kid_age');
    
    if (name != null && email != null && age != null) {
      _firstKid = {
        'name': name.toString(),
        'email': email.toString(),
        'age': age.toString(),
      };
    }

    // Load user name
    final userName = CacheHelper.getData(key: 'user_name');
    if (userName != null) {
      _userName = userName.toString();
    }

    // Load parent name
    final parentName = CacheHelper.getData(key: 'parent_name');
    if (parentName != null) {
      _parentName = parentName.toString();
    }

    // Load parent photo path
    final parentPhotoPath = CacheHelper.getData(key: 'parent_photo_path');
    if (parentPhotoPath != null) {
      _parentPhotoPath = parentPhotoPath.toString();
    }
  }
} 