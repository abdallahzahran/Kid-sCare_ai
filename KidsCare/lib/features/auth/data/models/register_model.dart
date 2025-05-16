class RegisterModel {
  final String? username;
  final String email;
  final String password;
  final String? message; // خليناه nullable
  final int? statusCode; // خليناه nullable

  RegisterModel({this.username, required this.email, required this.password, this.message, this.statusCode});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    final success = json['success'];
    return RegisterModel(
      message: success['message'], // نفترض إن الـ message هنا
      statusCode: success['status_code'], // ونفترض إن الـ statusCode هنا
      email: '',
      password: '',
      username: '',
    );
  }
}