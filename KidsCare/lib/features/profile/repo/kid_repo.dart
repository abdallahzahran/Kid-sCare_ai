import '../models/kid_model.dart';

class KidRepo {
  List<KidModel> _kids = [
    KidModel(
      id: '1',
      name: 'Ali Mohamed',
      age: 7,
      email: 'Mohamed_sayed@gmail.com',
      image: null,
    ),
  ];

  Future<List<KidModel>> getKids() async {
    await Future.delayed(Duration(seconds: 1));
    return _kids;
  }

  Future<List<KidModel>> addKid(KidModel data) async {
    await Future.delayed(Duration(seconds: 1));
    _kids.add(data);
    return _kids;
  }

  Future<List<KidModel>> updateKid(KidModel data) async {
    await Future.delayed(Duration(seconds: 1));
    _kids = _kids.map((kid) => kid.id == data.id ? data : kid).toList();
    return _kids;
  }

  Future<List<KidModel>> deleteKid(String id) async {
    await Future.delayed(Duration(seconds: 1));
    _kids.removeWhere((kid) => kid.id == id);
    return _kids;
  }
} 