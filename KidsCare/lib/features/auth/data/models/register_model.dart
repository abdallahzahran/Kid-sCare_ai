class RegisterModel {
  final String? username;
  final String email;
  final String password;
  final String? message; // خليناه nullable
  final int? statusCode; // خليناه nullable

  RegisterModel({this.username, required this.email, required this.password, this.message, this.statusCode});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      message: json['message'],
      statusCode: json['status_code'],
      email: json['email'] ?? '',
      password: '',
      username: json['username'] ?? '',
    );
  }
}