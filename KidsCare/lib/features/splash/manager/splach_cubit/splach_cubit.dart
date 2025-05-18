import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart'; // Import Material for WidgetsBinding
import 'package:kidscare/features/splash/manager/splach_cubit/splach_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial()); // الحالة الأولية تكون SplashInitial

  // الدالة المسؤولة عن بدء العد التنازلي لإزالة شاشة الـ Splash
  void startSplash() {
    // Schedule the delayed state change to happen after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3)); // الانتظار لمدة 3 ثواني
      emit(SplashCompleted()); // التغيير إلى الحالة SplashCompleted
    });
  }
}
