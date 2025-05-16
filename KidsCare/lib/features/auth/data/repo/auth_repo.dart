import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/register_model.dart';

class AuthRepo {
  final String _registerUrl = "https://authentication-node-sigma.vercel.app/api/auth/register";
  final String _loginUrl = "https://authentication-node-sigma.vercel.app/api/auth/login";

  Future<Map<String, dynamic>> register(RegisterModel registerModel) async {
    try {
      final response = await http.post(
        Uri.parse(_registerUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": registerModel.username,
          "email": registerModel.email,
          "password": registerModel.password,
        }),
      );

      return jsonDecode(response.body); // Return the entire response body
    } catch (e) {
      throw Exception("Registration error: $e");
    }
  }

  Future<Map<String, dynamic>> login(String input, String password) async {
    try {
      final isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);
      String email = input;

      if (!isEmail) {
        final userResponse = await http.get(Uri.parse('https://authentication-node-sigma.vercel.app/api/auth/login/get-email-from-username?username=$input'));

        if (userResponse.statusCode == 200) {
          final data = jsonDecode(userResponse.body);
          email = data['email'];
        } else {
          return {
            'status_code': 401,
            'message': 'Username not found',
          };
        }
      }

      final response = await http.post(
        Uri.parse('https://authentication-node-sigma.vercel.app/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final result = jsonDecode(response.body);
      return {
        'status_code': response.statusCode,
        'message': result['message'],
      };
    } catch (e) {
      return {
        'status_code': 500,
        'message': 'Server error',
      };
    }
  }
}