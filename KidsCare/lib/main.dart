import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/core/utils/app_text_styles.dart';
import 'package:kidscare/features/auth/manager/login_cubit/login_cubit.dart';
import 'package:kidscare/features/auth/manager/register_cubit/register_cubit.dart';
import 'package:kidscare/features/auth/views/login_view.dart';
import 'package:kidscare/features/auth/views/register_view.dart';
import 'package:kidscare/features/splash/views/add_kid.dart';
import 'package:kidscare/features/splash/views/choose_user_view.dart';
import 'package:kidscare/features/home/views/home_view.dart';
import 'features/time/manager/cubit/time_cubit/time_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await CacheHelper.init();
  FlutterNativeSplash.remove();
  runApp(
      BlocProvider(
          create: (_) => TimeCubit(),
     child:  const KidsCareApp()));
}

class KidsCareApp extends StatelessWidget {
  const KidsCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider<RegisterCubit>(create: (context) => RegisterCubit()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: AppTextStyles.fontFamily,
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          useMaterial3: true, // <-- هذا السطر يُفعل Material 3
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.yellow),
        ),
        home: const ChooseUserView(),
        getPages: [
          GetPage(name: '/login', page: () => const LoginView()),
          GetPage(name: '/registerParent', page: () => const RegisterView()),
          GetPage(name: '/registerKid', page: () => const AddKidSplachView()),
          GetPage(name: '/home', page: () => HomeView()),
          GetPage(name: '/add_kid', page: () => const AddKidSplachView()),
        ],
      ),
    );
  }
}
