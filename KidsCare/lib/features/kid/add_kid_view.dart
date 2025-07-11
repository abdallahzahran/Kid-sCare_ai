import 'package:flutter/material.dart';
import 'package:kidscare/core/widget/custom_text_form.dart';
import 'package:kidscare/features/home/widgets/custom_action_btn.dart';
import '../../core/helper/my_bottom_sheet.dart';
import '../../core/helper/my_responsive.dart';
import '../../core/helper/my_validator.dart';
import '../../core/utils/app_assets.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_text_styles.dart';
import '../../core/widget/custom_elvated_btn.dart';
import '../../core/widget/custom_svg.dart';
import 'package:kidscare/core/services/kids_service.dart';

class RegisterKidView extends StatelessWidget {
  // 1. الدالة التي ستُستدعى بعد إضافة الطفل (مطلوبة)
  final Function(Map<String, String>) onKidAdded;

  RegisterKidView({super.key, required this.onKidAdded});

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
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
                  CustomTextFormField(
                    controller: nameController,
                    label: 'Child Name',
                    textStyle: AppTextStyles.second,
                    horizontalPadding: 0,
                    validator: RequiredValidator(),
                  ),
                  CustomTextFormField(
                    controller: ageController,
                    label: 'Age',
                    textStyle: AppTextStyles.second,
                    horizontalPadding: 0,
                    validator: PositiveIntegerValidator(),
                  ),
                  CustomTextFormField(
                    controller: emailController,
                    label: 'Email',
                    textStyle: AppTextStyles.second,
                    horizontalPadding: 0,
                    validator: EmailValidator(),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomElevatedButton(
                    textButton: 'Done',
                    shadowColor: AppColors.yellowLight,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newKidData = {
                          'name': nameController.text,
                          'email': emailController.text,
                          'age': ageController.text,
                        };
                        KidsService().addKid(newKidData);

                        // 3. استدعاء الدالة وتمرير بيانات الطفل الجديدة
                        // هذه الدالة لا تزال ضرورية لأن HomeTab قد يناديها
                        onKidAdded(newKidData);

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('The child has been added successfully',style: TextStyle(color: AppColors.blue),),
                            backgroundColor: AppColors.yellow,
                          ),
                        );
                      }
                    },
                    backgroundColor: AppColors.yellowLight,
                    foregroundColor: AppColors.blue,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PositiveIntegerValidator extends AppValidator {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return 'Age is required';
    final age = int.tryParse(value);
    if (age == null) return 'Enter a valid age';
    if (age <= 0) return 'Enter a positive age';
    return null;
  }
}