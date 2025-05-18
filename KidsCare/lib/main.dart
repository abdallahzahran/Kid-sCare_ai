import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kidscare/core/cache/cache_data.dart';
import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/features/auth/views/login_view.dart';
import 'package:kidscare/features/auth/views/register_view.dart';
import 'package:kidscare/features/home/views/home_view.dart';
import 'package:kidscare/features/splash/views/add_kid.dart';
import 'package:kidscare/features/splash/views/choose_user_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await CacheData.loadFromCache();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KidsCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
        future: CacheData.checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final isLoggedIn = snapshot.data ?? false;
          if (isLoggedIn) {
            return const HomeView();
          }

          return FutureBuilder<bool>(
            future: CacheData.needsRegistration(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final needsRegistration = snapshot.data ?? false;
              if (needsRegistration) {
                return const RegisterView();
              }

              return const ChooseUserView();
            },
          );
        },
      ),
      getPages: [
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(name: '/register', page: () => const RegisterView()),
        GetPage(name: '/home', page: () => const HomeView()),
        GetPage(name: '/add_kid', page: () => AddKidSplachView()),
        GetPage(name: '/choose_user', page: () => const ChooseUserView()),
      ],
    );
  }
}
