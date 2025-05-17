import 'package:flutter/material.dart';
import 'package:get/get.dart'; // استورد Get
import 'package:kidscare/core/utils/app_assets.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/widget/custom_text_form.dart';

import '../../../core/helper/my_validator.dart';
import '../../../core/utils/app_text_styles.dart';
import '../../../core/helper/my_responsive.dart';
import 'package:kidscare/core/services/kids_service.dart';

class AddKidSplachView extends StatelessWidget {
  AddKidSplachView({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double verticalSpacing = MyResponsive.height(context, value: 24);
    final double fieldSpacing = MyResponsive.height(context, value: 20);
    final double buttonSpacing = MyResponsive.height(context, value: 32);
    final double maxFormWidth = MyResponsive.width(context, value: 350);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxFormWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Kid Info',
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: verticalSpacing),
                CustomTextFormField(
                  controller: nameController,
                  label: 'Name',
                  textStyle: AppTextStyles.first,
                  prefixIconPath: AppAssets.user,
                  validator: RequiredValidator(),
                ),
                SizedBox(height: fieldSpacing),
                CustomTextFormField(
                  controller: emailController,
                  label: 'Email',
                  textStyle: AppTextStyles.first,
                  prefixIconPath: AppAssets.user,
                  validator: RequiredValidator(),
                ),
                SizedBox(height: buttonSpacing),
                CustomElevatedButton(
                  textButton: 'Done',
                  onPressed: () {
                    KidsService().addKid({
                      'name': nameController.text,
                      'email': emailController.text,
                    });
                    Get.offAllNamed('/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}