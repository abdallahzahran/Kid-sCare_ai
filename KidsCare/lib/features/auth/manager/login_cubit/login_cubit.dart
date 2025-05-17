import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/auth_repo.dart';
import 'login_state.dart';
import '../../../../core/services/kids_service.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/services/navigation_service.dart';

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

  Future<void> onLoginPressed() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoadingState());

      try {
        final response = await _authRepo.login(
          emailOrUsernameController.text.trim(),
          passwordController.text.trim(),
        );

        if (response['status_code'] == 200) {
          // Save user session
          await CacheHelper.saveUserSession(
            email: response['email'] ?? emailOrUsernameController.text,
            username: response['username'] ?? '',
            isLoggedIn: true,
          );
          
          // Update KidsService with user info
          await KidsService().setParentName(response['username'] ?? '');
          
          emit(LoginSuccessState());
          NavigationService.toHome();
        } else {
          final errorMessage = response['message'] ?? 'Login failed';
          emit(LoginErrorState(errorMessage));
        }
      } catch (e) {
        emit(LoginErrorState('An error occurred. Please try again.'));
      }
    } else {
      emit(LoginErrorState('Please fill in all fields correctly.'));
    }
  }

  Future<void> checkLoginStatus() async {
    final session = CacheHelper.getUserSession();
    if (session != null && session['isLoggedIn'] == true) {
      final username = session['username'];
      if (username != null) {
        await KidsService().setParentName(username);
      }
      emit(LoginSuccessState());
    }
  }

  Future<void> logout() async {
    await CacheHelper.clearUserSession();
    await KidsService().clearAll();
    emit(LoginInitState());
    NavigationService.clearAndToLogin();
  }
}
