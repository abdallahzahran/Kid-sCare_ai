import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidscare/core/helper/my_navigator.dart';
import 'package:kidscare/features/home/views/home_view.dart';
import 'package:kidscare/features/splash/views/choose_user_view.dart';
import '../manager/splach_cubit/splach_cubit.dart';
import '../manager/splach_cubit/splach_state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..startSplash(),
      child: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashCompleted) {
            MyNavigator.goTo(screen: const ChooseUserView(), isReplace: true);
           // MyNavigator.goTo(screen: const HomeView(), isReplace: true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.14,
                width: MediaQuery.of(context).size.width * 0.59,
                child: Image.asset('assets/icons/splach.png'),
              ),
            ),
          );
        },
      ),
    );
  }
}
