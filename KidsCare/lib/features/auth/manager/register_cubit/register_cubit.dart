import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/register_model.dart';
import '../../data/repo/auth_repo.dart';
import 'register_state.dart';
import '../../../../core/services/kids_service.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/cache/cache_data.dart';

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

  Future<void> onRegisterPressed() async {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        emit(RegisterErrorState('Passwords do not match'));
        return;
      }

      emit(RegisterLoadingState());
      try {
        print('Registering with username: ${usernameController.text}, email: ${emailController.text}');
        final registerModel = RegisterModel(
          username: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
        );
        
        final response = await _authRepo.register(registerModel);
        print('Registration API response: $response');

        if (response['status_code'] == 200 || response['status_code'] == 201) {
          print('Registration successful');
          
          // Save user data in cache
          await CacheHelper.saveData(key: CacheKeys.isLoggedIn, value: true);
          await CacheHelper.saveData(key: CacheKeys.userEmail, value: emailController.text);
          await CacheHelper.saveData(key: CacheKeys.username, value: usernameController.text);
          await CacheHelper.saveData(key: CacheKeys.password, value: passwordController.text);
          
          // Set registration as not complete yet (will be completed after adding kid)
          await CacheData.setRegistrationComplete(false);
          
          // Save parent name in KidsService
          KidsService().setParentName(usernameController.text);
          print('Parent name saved');
          
          emit(RegisterSuccessState(RegisterModel.fromJson(response)));
          print('Emitted RegisterSuccessState');
        } else {
          final errorMessage = response['message'] ?? 'Registration failed';
          print('Registration failed with message: $errorMessage');
          emit(RegisterErrorState(errorMessage));
          print('Emitted RegisterErrorState');
        }
      } catch (e) {
        print('Registration exception caught: $e');
        emit(RegisterErrorState('An unexpected error occurred: ${e.toString()}'));
        print('Emitted RegisterErrorState from catch block');
      }
    } else {
      emit(RegisterErrorState('Please fill in all fields correctly.'));
      print('Form validation failed');
    }
  }

  Future<void> checkRegistrationStatus() async {
    try {
      final isLoggedIn = CacheHelper.getData(key: CacheKeys.isLoggedIn) ?? false;
      if (isLoggedIn) {
        final username = CacheHelper.getData(key: CacheKeys.username)?.toString();
        final email = CacheHelper.getData(key: CacheKeys.userEmail)?.toString();
        if (username != null && email != null) {
          KidsService().setParentName(username);
          emit(RegisterSuccessState(RegisterModel(
            username: username,
            email: email,
            password: '', // Don't load password from cache for security
          )));
        }
      }
    } catch (e) {
      print('Error checking registration status: $e');
      emit(RegisterErrorState('Error checking registration status'));
    }
  }
}