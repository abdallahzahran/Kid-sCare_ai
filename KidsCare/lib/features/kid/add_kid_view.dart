import 'package:flutter/material.dart';
import 'package:kidscare/core/widget/custom_text_form.dart';
import 'package:kidscare/features/home/widgets/custom_action_btn.dart';
import '../../core/helper/my_bottom_sheet.dart';
import '../../core/helper/my_navigator.dart';
import '../../core/helper/my_responsive.dart';
import '../../core/helper/my_validator.dart';
import '../../core/utils/app_assets.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_text_styles.dart';
import '../../core/widget/custom_elvated_btn.dart';
import '../../core/widget/custom_svg.dart';
import '../auth/views/login_view.dart';

class RegisterKidView extends StatelessWidget {
  const RegisterKidView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomActionBottom(
      icon: CustomSvg(assetPath: AppAssets.addKid),
      onPressed: () {
        MyBottomSheet(
          context: context,
          height: MyResponsive.height(context, value: 600),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Add Kid',
                    style: TextStyle(fontSize: 25, color: AppColors.yellowLight),
                  ),
                ),
                const Divider(thickness: 0.2,),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                // صورة الطفل مع زرار الكاميرا
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        MyNavigator.goTo(screen: LoginView());
                      },
                      child: Container(
                       // margin: const EdgeInsetsDirectional.only(end: 16),
                        height: MyResponsive.height(context, value: 120),
                        width: MyResponsive.height(context, value: 120),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(AppAssets.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: CustomSvg(assetPath: AppAssets.user),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                // الفورمز
                CustomTextFormField(
                  label: 'Child Name',
                  textStyle: AppTextStyles.second,
                  horizontalPadding: 0,
                  // prefixIconPath: AppAssets.user,
                  validator: RequiredValidator(),
                ),
                CustomTextFormField(
                  label: 'Age',
                  textStyle: AppTextStyles.second,
                  horizontalPadding: 0,
                  // prefixIconPath: AppAssets.user,
                  validator: RequiredValidator(),
                ),
                CustomTextFormField(
                  label: 'Email',
                  textStyle: AppTextStyles.second,
                 horizontalPadding: 0,
                 // prefixIconPath: AppAssets.user,
                  validator: EmailValidator(),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                CustomElevatedButton(
                  textButton: 'Done',
                  shadowColor: AppColors.yellowLight,
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('The child has been added successfully',style: TextStyle(color: AppColors.blue),),
                        backgroundColor: AppColors.yellow,
                      ),
                    );
                  },
                  backgroundColor: AppColors.yellowLight,
                  foregroundColor: AppColors.blue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
