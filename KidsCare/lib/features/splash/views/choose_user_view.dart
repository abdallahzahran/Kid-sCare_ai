import 'package:flutter/material.dart';
import 'package:get/get.dart'; // تأكد من أنك تستخدم GetX إذا كان هذا Import ضروريًا
import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/core/cache/cache_keys.dart';
import 'package:kidscare/core/helper/my_navigator.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/widget/custom_svg.dart';
import 'package:kidscare/features/auth/views/register_view.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/helper/my_responsive.dart';
import '../../kid/add_kid_view.dart';

class ChooseUserView extends StatelessWidget {
  const ChooseUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final double verticalSpacing = MyResponsive.height(context, value: 40);
    final double maxFormWidth = MyResponsive.width(context, value: 350);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxFormWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: verticalSpacing),
                CustomSvg(assetPath: AppAssets.logo),
                SizedBox(height: verticalSpacing),
                CustomElevatedButton(
                  textButton: 'Parent',
                  onPressed: () async {
                    try {
                      await CacheHelper.saveData(key: CacheKeys.userType, value: 'parent');
                      MyNavigator.goTo(screen: const RegisterView(), isReplace: true);
                    } catch (e) {
                      print('Error saving user type: $e');
                    }
                  },
                ),
                SizedBox(height: verticalSpacing),
                CustomElevatedButton(
                  textButton: 'Kid',
                  onPressed: () async {
                    try {
                      await CacheHelper.saveData(key: CacheKeys.userType, value: 'kid');
                      // ############# حل المشكلة هنا #############
                      MyNavigator.goTo(
                        screen: RegisterKidView(
                          onKidAdded: (kidData) {
                            // هذه الدالة ستُستدعى عند إضافة طفل بنجاح
                            // ولكن في هذا السياق (ChooseUserView)، قد لا تحتاج لعمل أي شيء هنا
                            // لأن الشاشة التالية (الـ Home بعد إضافة الطفل) هي من ستعرض البيانات
                            print('Kid added from ChooseUserView, data: $kidData');
                          },
                        ),
                        isReplace: true,
                      );
                      // #########################################
                    } catch (e) {
                      print('Error saving user type: $e');
                    }
                  },
                ),
                SizedBox(height: verticalSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}