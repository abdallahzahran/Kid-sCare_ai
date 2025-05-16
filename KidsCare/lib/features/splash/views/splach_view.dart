import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidscare/features/auth/views/login_view.dart';
import 'package:kidscare/features/splash/views/add_kid.dart';
import 'package:kidscare/features/splash/views/choose_user_view.dart';
import '../manager/splach_cubit/splach_cubit.dart';
import '../manager/splach_cubit/splach_state.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..startSplash(),
      child: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          if (state is SplashCompleted) {
            return const ChooseUserView();
          }

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
