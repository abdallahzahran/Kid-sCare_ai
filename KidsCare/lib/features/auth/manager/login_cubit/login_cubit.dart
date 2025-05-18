import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/auth_repo.dart';
import 'login_state.dart';
import '../../../../core/services/kids_service.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_keys.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);

  final AuthRepo _authRepo = AuthRepo();

  TextEditingController emailOrUsernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginInitState());
  }

  void onLoginPressed() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoadingState());

      try {
        print('Attempting login with: ${emailOrUsernameController.text}');
        final response = await _authRepo.login(
          emailOrUsernameController.text.trim(),
          passwordController.text.trim(),
        );

        print('Login response: $response');

        if (response['status_code'] == 200) {
          // Save user session
          await CacheHelper.saveData(key: CacheKeys.isLoggedIn, value: true);
          await CacheHelper.saveData(key: CacheKeys.userEmail, value: response['email'] ?? emailOrUsernameController.text);
          await CacheHelper.saveData(key: CacheKeys.username, value: response['username'] ?? '');
          await CacheHelper.saveData(key: CacheKeys.password, value: passwordController.text);
          
          // Update KidsService with user info
          KidsService().setParentName(response['username'] ?? '');
          
          emit(LoginSuccessState());
        } else {
          final errorMessage = response['message'] ?? 'Login failed';
          print('Login error: $errorMessage');
          emit(LoginErrorState(errorMessage));
        }
      } catch (e) {
        print('Login exception: $e');
        emit(LoginErrorState('An error occurred. Please try again.'));
      }
    } else {
      emit(LoginErrorState('Please fill in all fields correctly.'));
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      final isLoggedIn = CacheHelper.getData(key: CacheKeys.isLoggedIn) ?? false;
      if (isLoggedIn) {
        final username = CacheHelper.getData(key: CacheKeys.username)?.toString();
        final email = CacheHelper.getData(key: CacheKeys.userEmail)?.toString();
        if (username != null && email != null) {
          KidsService().setParentName(username);
          // Pre-fill the login form with cached data
          emailOrUsernameController.text = email;
          emit(LoginSuccessState());
        }
      }
    } catch (e) {
      print('Error checking login status: $e');
      emit(LoginErrorState('Error checking login status'));
    }
  }

  Future<void> logout() async {
    try {
      await CacheHelper.clearAllData();
      emit(LoginInitState());
    } catch (e) {
      print('Error during logout: $e');
      emit(LoginErrorState('Error during logout'));
    }
  }
}
