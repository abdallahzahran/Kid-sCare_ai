import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidscare/core/helper/my_validator.dart';
import 'package:kidscare/core/utils/app_assets.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/core/utils/app_text_styles.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/widget/custom_svg.dart';
import 'package:kidscare/core/widget/custom_text_form.dart';
import 'package:kidscare/features/auth/views/register_view.dart';
import '../../../core/utils/app_constants.dart';
import '../../home/views/home_view.dart';
import '../manager/login_cubit/login_cubit.dart';
import '../manager/login_cubit/login_state.dart';
import '../../../core/helper/my_responsive.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final double verticalSpacing = MyResponsive.height(context, value: 24);
    final double fieldSpacing = MyResponsive.height(context, value: 20);
    final double buttonSpacing = MyResponsive.height(context, value: 32);
    final double logoSpacing = MyResponsive.height(context, value: 30);
    final double registerSpacing = MyResponsive.height(context, value: 40);
    final double maxFormWidth = MyResponsive.width(context, value: 350);

    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login Successful',style: TextStyle(color: AppColors.blue),),
                    backgroundColor: AppColors.yellow),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              );
            } else if (state is LoginErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            var cubit = LoginCubit.get(context);
            return Form(
              key: cubit.formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxFormWidth),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: verticalSpacing),
                          CustomSvg(assetPath: AppAssets.logo),
                          SizedBox(height: logoSpacing),
                          CustomTextFormField(
                            label: 'Email or Username',
                            textStyle: AppTextStyles.first,
                            prefixIconPath: AppAssets.user,
                            controller: cubit.emailOrUsernameController,
                            validator: RequiredValidator(),
                          ),
                          CustomTextFormField(
                            label: 'Password',
                            textStyle:AppTextStyles.first ,
                            prefixIconPath: AppAssets.password,
                            suffixIconPath: cubit.isPasswordVisible
                                ? AppAssets.passwordEnable
                                : AppAssets.passwordDisable,
                            obscureText: !cubit.isPasswordVisible,
                            controller: cubit.passwordController,
                            validator: PasswordValidator(),
                            onSuffixIconTap: () {
                              cubit.togglePasswordVisibility();
                            },
                          ),
                          SizedBox(height: fieldSpacing),
                          CustomElevatedButton(
                            textButton: state is LoginLoadingState ? 'Loading...' : 'Login',
                            onPressed: cubit.onLoginPressed,
                          ),
                          SizedBox(height: buttonSpacing),
                          RichText(
                            text: TextSpan(
                              text: 'Don’t Have An Account?  ',
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'Register',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.yellow,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterView(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: registerSpacing),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
