import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/auth_repo.dart';
import 'login_state.dart';
import '../../../../core/services/kids_service.dart';
import '../../../../core/cache/cache_helper.dart';

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
        print('Attempting login with: ${emailOrUsernameController.text}'); // Debug print
        final response = await _authRepo.login(
          emailOrUsernameController.text.trim(),
          passwordController.text.trim(),
        );

        print('Login response: $response'); // Debug print

        if (response['status_code'] == 200) {
          // Save user session
          await CacheHelper.saveData(key: 'isLoggedIn', value: true);
          await CacheHelper.saveData(key: 'userEmail', value: response['email'] ?? emailOrUsernameController.text);
          await CacheHelper.saveData(key: 'username', value: response['username'] ?? '');
          
          // Update KidsService with user info
          KidsService().setParentName(response['username'] ?? '');
          
          emit(LoginSuccessState());
        } else {
          final errorMessage = response['message'] ?? 'Login failed';
          print('Login error: $errorMessage'); // Debug print
          emit(LoginErrorState(errorMessage));
        }
      } catch (e) {
        print('Login exception: $e'); // Debug print
        emit(LoginErrorState('An error occurred. Please try again.'));
      }
    } else {
      emit(LoginErrorState('Please fill in all fields correctly.'));
    }
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = CacheHelper.getData(key: 'isLoggedIn') ?? false;
    if (isLoggedIn) {
      final username = CacheHelper.getData(key: 'username')?.toString();
      if (username != null) {
        KidsService().setParentName(username);
      }
      emit(LoginSuccessState());
    }
  }
}
