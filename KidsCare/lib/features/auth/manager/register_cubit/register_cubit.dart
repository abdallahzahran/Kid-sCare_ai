import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/register_model.dart';
import '../../data/repo/auth_repo.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepo _authRepo = AuthRepo();

  RegisterCubit() : super(RegisterInitState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(RegisterInitState());
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(RegisterInitState());
  }

  void onRegisterPressed() async {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        emit(RegisterErrorState('Passwords do not match'));
        return;
      }

      final registerModel = RegisterModel(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      
      emit(RegisterLoadingState());
      
      try {
        final response = await _authRepo.register(registerModel);
        print('Registration response: $response'); // Debug print

        if (response['status_code'] == 200 || response['status_code'] == 201) {
          final successRegisterModel = RegisterModel.fromJson(response);
          emit(RegisterSuccessState(successRegisterModel));
          print('User registered successfully: ${successRegisterModel.message}');
        } else {
          String errorMessage = response['message'] ?? 'An error occurred';
          if (errorMessage.toLowerCase().contains('already exists')) {
            errorMessage = 'This email or username is already registered. Please try logging in.';
          }
          emit(RegisterErrorState(errorMessage));
          print('Error: $errorMessage');
        }
      } catch (e) {
        emit(RegisterErrorState('Registration error: $e'));
        print('Error: $e');
      }
    } else {
      emit(RegisterErrorState('Please fill in all fields correctly.'));
    }
  }
}