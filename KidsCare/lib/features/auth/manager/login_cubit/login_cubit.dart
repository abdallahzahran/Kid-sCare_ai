import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/auth_repo.dart';
import 'login_state.dart';

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
        final response = await _authRepo.login(
          emailOrUsernameController.text.trim(),
          passwordController.text.trim(),
        );

        if (response['status_code'] == 200) {
          emit(LoginSuccessState());
        } else {
          emit(LoginErrorState(response['message'] ?? 'Login failed'));
        }
      } catch (e) {
        emit(LoginErrorState('Server Error: ${e.toString()}'));
      }
    } else {
      emit(LoginErrorState('Please fill in all fields correctly.'));
    }
  }
}
