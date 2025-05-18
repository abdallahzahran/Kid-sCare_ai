import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:kidscare/core/utils/app_assets.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/widget/custom_svg.dart';
import 'package:kidscare/core/widget/custom_text_form.dart';
import 'package:kidscare/features/auth/views/login_view.dart';
import 'package:kidscare/features/splash/views/add_kid.dart';
import '../../../core/helper/my_navigator.dart';
import '../../../core/helper/my_validator.dart';
import '../../../core/utils/app_text_styles.dart';
import '../manager/register_cubit/register_cubit.dart';
import '../manager/register_cubit/register_state.dart';
import '../../../core/helper/my_responsive.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

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
        create: (BuildContext context) => RegisterCubit(),
        child: Builder(
          builder: (context) {
            return BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.registerModel.message ?? 'Registration successful! Adding your first kid...'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Get.offAllNamed('/add_kid');
                } else if (state is RegisterErrorState) {
                  String errorMessage = state.error;
                  if (errorMessage.toLowerCase().contains('already exists')) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Account Already Exists'),
                        content: Text('This email or username is already registered. Would you like to log in instead?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Get.offAllNamed('/login');
                            },
                            child: Text('Go to Login'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                  );
                  }
                }
              },
              builder: (context, state) {
                var cubit = RegisterCubit.get(context);
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
                                label: 'Username',
                                textStyle: AppTextStyles.first,
                                prefixIconPath: AppAssets.user,
                                controller: cubit.usernameController,
                                validator: RequiredValidator(),
                              ),
                              CustomTextFormField(
                                label: 'Email',
                                textStyle: AppTextStyles.first,
                                prefixIconPath: AppAssets.user,
                                controller: cubit.emailController,
                                validator: EmailValidator(),
                              ),
                              CustomTextFormField(
                                label: 'Password',
                                textStyle: AppTextStyles.first,
                                prefixIconPath: AppAssets.password,
                                suffixIconPath:
                                cubit.isPasswordVisible
                                    ? AppAssets.passwordEnable
                                    : AppAssets.passwordDisable,
                                obscureText: !cubit.isPasswordVisible,
                                controller: cubit.passwordController,
                                validator: PasswordValidator(),
                                onSuffixIconTap: () {
                                  cubit.togglePasswordVisibility();
                                },
                              ),
                              CustomTextFormField(
                                label: 'Confirm Password',
                                textStyle: AppTextStyles.first,
                                prefixIconPath: AppAssets.password,
                                suffixIconPath:
                                cubit.isConfirmPasswordVisible
                                    ? AppAssets.passwordEnable
                                    : AppAssets.passwordDisable,
                                obscureText: !cubit.isConfirmPasswordVisible,
                                controller: cubit.confirmPasswordController,
                                validator: PasswordValidator(),
                                onSuffixIconTap: () {
                                  cubit.toggleConfirmPasswordVisibility();
                                },
                              ),
                              SizedBox(height: fieldSpacing),
                              state is RegisterLoadingState
                                  ? const CircularProgressIndicator()
                                  : CustomElevatedButton(
                                textButton: 'Register',
                                onPressed: () {
                                  cubit.onRegisterPressed();
                                },
                              ),
                              SizedBox(height: buttonSpacing),
                              RichText(
                                text: TextSpan(
                                  text: 'Already have an account?  ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.yellow,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                         MyNavigator.goTo(screen: LoginView(),isReplace: true);
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
            );
          },
        ),
      ),
    );
  }
}