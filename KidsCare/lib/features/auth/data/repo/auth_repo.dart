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

      final responseData = jsonDecode(response.body);
      print('Raw API Response: $responseData'); // Debug print

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'status_code': response.statusCode,
          'message': 'Registration successful',
          'email': registerModel.email,
          'username': registerModel.username,
        };
      } else {
        // Handle error response
        final errorMessage = responseData['message'] ?? 'Registration failed';
        return {
          'status_code': response.statusCode,
          'message': errorMessage,
        };
      }
    } catch (e) {
      print('Registration error: $e'); // Debug print
      return {
        'status_code': 500,
        'message': 'Network error occurred. Please try again.',
      };
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
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);
      print('Login API Response: $responseData'); // Debug print

      if (response.statusCode == 200) {
        return {
          'status_code': 200,
          'message': 'Login successful',
          'email': email,
          'username': responseData['username'] ?? input,
        };
      } else {
        return {
          'status_code': response.statusCode,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('Login error: $e'); // Debug print
      return {
        'status_code': 500,
        'message': 'Network error occurred. Please try again.',
      };
    }
  }
}