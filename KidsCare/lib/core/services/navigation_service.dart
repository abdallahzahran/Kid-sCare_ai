import 'package:get/get.dart';
import 'package:kidscare/features/auth/views/login_view.dart';
import 'package:kidscare/features/auth/views/register_view.dart';
import 'package:kidscare/features/home/views/home_view.dart';
import 'package:kidscare/features/splash/views/add_kid.dart';
import 'package:kidscare/features/splash/views/choose_user_view.dart';

class NavigationService {
  static void toLogin() => Get.offAllNamed('/login');
  static void toRegister() => Get.toNamed('/registerParent');
  static void toHome() => Get.offAllNamed('/home');
  static void toAddKid() => Get.toNamed('/add_kid');
  static void toChooseUser() => Get.offAllNamed('/');
  
  static void back() => Get.back();
  
  static void clearAndToLogin() {
    Get.offAll(() => const LoginView());
  }
  
  static void clearAndToHome() {
    Get.offAll(() => HomeView());
  }
  
  static void clearAndToChooseUser() {
    Get.offAll(() => const ChooseUserView());
  }
} 