import 'package:kidscare/core/cache/cache_helper.dart';

class KidsService {
  static final KidsService _instance = KidsService._internal();
  factory KidsService() => _instance;
  KidsService._internal();

  String? _parentName;
  String? _parentPhotoPath;
  List<Map<String, dynamic>> _kids = [];

  String? get parentName => _parentName;
  String? get parentPhotoPath => _parentPhotoPath;
  List<Map<String, dynamic>> get kids => List.unmodifiable(_kids);

  Future<void> setParentName(String name) async {
    _parentName = name;
    await CacheHelper.saveData(key: 'parentName', value: name);
  }

  Future<void> setParentPhotoPath(String path) async {
    _parentPhotoPath = path;
    await CacheHelper.saveData(key: 'parentPhotoPath', value: path);
  }

  Future<void> addKid(Map<String, dynamic> kid) async {
    _kids.add(kid);
    await _saveKidsData();
  }

  Future<void> removeKid(int index) async {
    if (index >= 0 && index < _kids.length) {
      _kids.removeAt(index);
      await _saveKidsData();
    }
  }

  Future<void> updateKid(int index, Map<String, dynamic> updatedKid) async {
    if (index >= 0 && index < _kids.length) {
      _kids[index] = updatedKid;
      await _saveKidsData();
    }
  }

  Future<void> _saveKidsData() async {
    await CacheHelper.saveKidsData(_kids);
  }

  Future<void> loadFromCache() async {
    _parentName = CacheHelper.getData(key: 'parentName');
    _parentPhotoPath = CacheHelper.getData(key: 'parentPhotoPath');
    _kids = await CacheHelper.getKidsData();
  }

  Future<void> clearAll() async {
    _parentName = null;
    _parentPhotoPath = null;
    _kids.clear();
    await CacheHelper.removeData(key: 'parentName');
    await CacheHelper.removeData(key: 'parentPhotoPath');
    await CacheHelper.removeData(key: 'kids');
  }

  Future<void> updateFirstKid(int index) async {
    if (index >= 0 && index < _kids.length) {
      final kid = _kids.removeAt(index);
      _kids.insert(0, kid);
      await _saveKidsData();
    }
  }
} 