class KidsService {
  static final KidsService _instance = KidsService._internal();
  factory KidsService() => _instance;
  KidsService._internal();

  final List<Map<String, String>> _kids = [
    {'name': 'ALi Mohmed', 'email': 'Mohamed_sayed@gmail.com'},
    {'name': 'Abdallah Mohmed', 'email': 'abdallah@gmail.com'},
    {'name': 'Hassan Mohmed', 'email': 'hassan@gmail.com'},
  ];

  List<Map<String, String>> get kids => _kids;

  void addKid(Map<String, String> kid) {
    _kids.add(kid);
  }

  void updateKid(int index, Map<String, String> kid) {
    _kids[index] = kid;
  }
} 