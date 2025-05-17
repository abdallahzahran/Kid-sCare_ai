import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/register_model.dart';
import '../../data/repo/auth_repo.dart';
import 'register_state.dart';
import '../../../../core/services/kids_service.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/services/navigation_service.dart';

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
        final registerModel = RegisterModel(
          username: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
        );
        
        final response = await _authRepo.register(registerModel);
        
        if (response['status_code'] == 200 || response['status_code'] == 201) {
          // Save user session
          await CacheHelper.saveUserSession(
            email: emailController.text,
            username: usernameController.text,
            isLoggedIn: true,
          );
          
          // Save parent name
          await KidsService().setParentName(usernameController.text);
          
          emit(RegisterSuccessState(RegisterModel.fromJson(response)));
          NavigationService.toAddKid();
        } else {
          emit(RegisterErrorState(response['message'] ?? 'Registration failed'));
        }
      } catch (e) {
        emit(RegisterErrorState(e.toString()));
      }
    } else {
      emit(RegisterErrorState('Please fill in all fields correctly.'));
    }
  }
}