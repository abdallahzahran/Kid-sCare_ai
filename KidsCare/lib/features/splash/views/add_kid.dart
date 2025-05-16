import 'package:flutter/material.dart';
import 'package:get/get.dart'; // استورد Get
import 'package:kidscare/core/utils/app_assets.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/widget/custom_text_form.dart';

import '../../../core/helper/my_validator.dart';
import '../../../core/utils/app_text_styles.dart';

class AddKidSplachView extends StatelessWidget {
  const AddKidSplachView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Kid Info',
            textAlign: TextAlign.start,
          ),
          CustomTextFormField(
            label: 'Name',
            textStyle: AppTextStyles.first,
            prefixIconPath: AppAssets.user,
            validator: RequiredValidator(),
          ),
          CustomTextFormField(
            label: 'Email',
            textStyle: AppTextStyles.first,
            prefixIconPath: AppAssets.user,
            validator: RequiredValidator(),
          ),
          CustomElevatedButton(
            textButton: 'Done',
            onPressed: () {
              // هنا ممكن تعمل حفظ لبيانات الطفل اللي تم إدخالها
              // ...

              Get.offAllNamed('/login'); // الانتقال لصفحة اللوجين باستخدام Get.offAllNamed
            },
          ),
        ],
      ),
    );
  }
}